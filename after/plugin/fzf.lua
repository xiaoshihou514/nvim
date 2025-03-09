local api = vim.api
local exepath = vim.fn.exepath

local function open_ivy_win()
    local height, width = vim.o.lines, vim.o.columns
    local pad_top = math.ceil(height * 0.2)
    local buf = api.nvim_create_buf(false, true)
    local win = api.nvim_open_win(buf, true, {
        relative = "editor",
        row = pad_top,
        col = 0,
        height = height - pad_top - 1,
        width = width,
        border = "none",
    })
    local opts = {
        matchpairs = "",
        buflisted = false,
        cursorcolumn = false,
        cursorline = false,
        list = false,
        number = false,
        relativenumber = false,
        spell = false,
        swapfile = false,
        filetype = "fzf",
        wrap = false,
        signcolumn = "no",
        scrolloff = 0,
        winbar = " ",
    }
    for opt, val in pairs(opts) do
        api.nvim_set_option_value(opt, val, { scope = "local" })
    end
    return win, buf
end

local fd = exepath("fd") == "" and exepath("fdfind") or exepath("fd")
local fzf = exepath("fzf")
local bat = exepath("bat") == "" and exepath("batcat") or exepath("bat")

local function execute(cmd, data, cwd)
    local win, buf = open_ivy_win()
    local id = vim.fn.jobstart(cmd, {
        term = true,
        clear_env = true,
        cwd = cwd,
        env = fd ~= ""
            and { FZF_DEFAULT_COMMAND = fd .. " -H --type f --strip-cwd-prefix" },
        on_exit = function()
            local ok, lines = pcall(api.nvim_buf_get_lines, buf, 0, -1, false)
            if not ok then
                return
            end
            -- HACK
            local line = vim.iter(lines):rev():find(function(ln)
                return ln ~= "" and not ln:match("[[Process exited %d]]")
            end)
            api.nvim_win_close(win, true)
            api.nvim_buf_delete(buf, { force = true })
            pcall(api.nvim_command, line)
        end,
    })
    if data then
        api.nvim_chan_send(id, type(data) == "table" and table.concat(data, "\n") or data)
        -- close stdin with C-d
        api.nvim_chan_send(id, "\n\x04")
    end
    -- HACK
    vim.defer_fn(function()
        api.nvim_command("silent! startinsert")
    end, 10)
end

local default = ([[%s --layout=reverse \
    --border=sharp \
    --preview='%s --theme=moonlight-ansi --color=always -pp {}'\
]]):format(fzf, bat)

local function make_bindings(...)
    return ([[
    --bind "ctrl-x:become:echo '%s'"\
    --bind "ctrl-o:become:echo '%s'"\
    --bind "ctrl-t:become:echo '%s'"\
    --bind "enter:become:echo '%s'"
    ]]):format(...)
end

local file_bind = make_bindings("vsplit {1}", "split {1}", "tabe {1}", "edit {1}")

local function get_history_file(purpose)
    return vim.fn.stdpath("data") .. "/" .. purpose .. ".history"
end

local cmds = {
    oldfiles = function()
        execute(
            "cat |" .. default .. file_bind,
            vim.tbl_filter(function(f)
                ---@diagnostic disable-next-line: undefined-field
                return vim.uv.fs_stat(f) ~= nil
                    and vim.iter({
                        "nvim%-nightly",
                        "^/tmp",
                        "^/usr",
                        "%.rustup",
                        "%.metals",
                    }):all(function(v, _)
                        return not f:match(v)
                    end)
            end, vim.v.oldfiles)
        )
    end,
    grep = function()
        execute(
            ([[echo 'Type to start grepping' | %s \
        --layout=reverse \
        --disabled --ansi \
        --border=sharp \
        --delimiter : \
        --preview='%s --theme=moonlight-ansi --color=always -pp --highlight-line {2} {1}'\
        --preview-window '+{2}/2' \
        --history %s \
        --bind "change:reload:rg --column --color=always {q} || :" \
        ]]):format(fzf, bat, get_history_file("fzf_grep"))
                .. make_bindings(
                    "vsplit {1} | {2}",
                    "split {1} | {2}",
                    "tabe {1} | {2}",
                    "edit {1} | {2}"
                )
        )
        -- HACK: fix the keybinds at the neovim level...
        bind("t", "<C-p>", "<Up>", { buffer = true })
        bind("t", "<C-n>", "<Down>", { buffer = true })
        bind("t", "<C-k>", "<C-p>", { buffer = true })
        bind("t", "<C-j>", "<C-n>", { buffer = true })
    end,
    cword = function()
        execute(
            ([[echo 'Type to start grepping' | %s \
        --layout=reverse \
        --disabled --ansi \
        --border=sharp \
        --delimiter : \
        --preview='%s --theme=moonlight-ansi --color=always -pp --highlight-line {2} {1}'\
        --preview-window '+{2}/2' \
        --bind "change:reload:rg --column --color=always {q} || :" \
        ]]):format(fzf, bat)
                .. make_bindings(
                    "vsplit {1} | {2}",
                    "split {1} | {2}",
                    "tabe {1} | {2}",
                    "edit {1} | {2}"
                )
        )
        vim.fn.expand("<cword>")
    end,
    files = function()
        execute(default .. file_bind)
    end,
    buffers = function()
        execute(
            ([[ cat | %s --border=sharp \ ]]):format(fzf)
                .. make_bindings(
                    "vnew | buffer {1}",
                    "new | buffer {1}",
                    "tabnew | buffer {1}",
                    "buffer {1}"
                ),
            api.nvim_exec2("buffers", { output = true }).output
        )
    end,
    ["files-cwd"] = function()
        local cwd = vim.fn.getcwd()
        execute(
            ([[%s . --maxdepth 1 --type f | ]]):format(fd)
                .. default
                .. make_bindings(
                    "vsplit %s/{1}",
                    "split %s/{1}",
                    "tabe %s/{1}",
                    "edit %s/{1}"
                ):format(cwd)
        )
    end,
    ["lsp-symbols"] = function()
        local significant = {
            5, -- Class
            6, -- Method
            10, -- Enum
            11, -- Interface
            12, -- Function
            23, -- Struct
        }

        local function collect_toplevel(map, results)
            vim.iter(results)
                :filter(function(it)
                    return vim.tbl_contains(significant, it.kind)
                end)
                :each(function(it)
                    table.insert(
                        map,
                        table.concat({
                            it.range["start"].line + 1,
                            it.name,
                        }, ":")
                    )
                end)

            vim.iter(results):each(function(it)
                if it.children then
                    collect_toplevel(map, it.children)
                end
            end)
        end
        local bufnr = vim.api.nvim_get_current_buf()
        local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }
        local client = vim.iter(vim.lsp.get_clients({ bufnr = bufnr })):find(function(it)
            return it:supports_method("textDocument/documentSymbol", bufnr)
        end)
        if not client then
            vim.notify("No lsp with documentSymbol capability found", vim.log.levels.WARN)
        end
        coroutine.resume(coroutine.create(function()
            local co = assert(coroutine.running())
            local success = client:request(
                "textDocument/documentSymbol",
                params,
                function(...)
                    coroutine.resume(co, ...)
                end,
                bufnr
            )

            local err, results = coroutine.yield()

            if not success or err then
                vim.notify("Failed to fetch documentSymbol from lsp", vim.log.levels.WARN)
                return
            end

            local map = {}
            collect_toplevel(map, results)

            execute(
                ([[cat | %s --layout=reverse \
            --border=sharp \
            --delimiter : \
            --preview='%s --theme=moonlight-ansi --color=always -pp --line-range {1}: --highlight-line {1} %s'\
            ]]):format(fzf, bat, vim.fn.expand("%f"))
                    .. make_bindings(
                        "vsplit | {1} | ",
                        "split | {1}",
                        "tabe %% | {1}",
                        "{1}"
                    ),
                table.concat(map, "\n")
            )
        end))
    end,
}

api.nvim_create_user_command("Fzf", function(opts)
    local f = cmds[opts.args]
    _ = not f and vim.notify("Invalid subcommand: " .. opts.args) or f()
end, {
    nargs = 1,
    complete = function(arg_lead, cmdline, _)
        if cmdline:match("Fzf*%s+%w*$") then
            return vim.iter(vim.tbl_keys(cmds))
                :filter(function(key)
                    return key:find(arg_lead) ~= nil
                end)
                :totable()
        end
    end,
})

bind("n", "<leader>r", "<cmd>Fzf oldfiles<cr>")
bind("n", "<leader>g", "<cmd>Fzf grep<cr>")
bind("n", "<leader>s", "<cmd>Fzf cword<cr>")
bind("n", "<leader>f", "<cmd>Fzf files<cr>")
bind("n", "<leader>;", "<cmd>enew | lcd ~/.config/nvim/ | Fzf files<cr>")
bind("n", "<leader>b", "<cmd>Fzf buffers<cr>")
bind("n", "<leader>t", "<cmd>Fzf lsp-symbols<cr>")
