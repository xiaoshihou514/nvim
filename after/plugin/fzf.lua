local api = vim.api

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

local function execute(cmd, data)
    local win, buf = open_ivy_win()
    local id = vim.fn.termopen(cmd, {
        clear_env = true,
        env = { FZF_DEFAULT_COMMAND = "fd -H --type f --strip-cwd-prefix" },
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
            -- api.nvim_command(line)
            local ok, _ = pcall(api.nvim_command, line)
            if not ok then
                vim.print(line)
                vim.print(lines)
            end
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

local default = [[
fzf --layout=reverse \
    --border=sharp \
    --preview='bat --theme=moonlight-ansi --color=always -pp {}'\
]]

local file_bind = [[
    --bind "ctrl-x:become:echo 'vsplit {1}'"\
    --bind "ctrl-o:become:echo 'split {1}'"\
    --bind "enter:become:echo 'edit {1}'"
]]

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
        execute([[
        echo 'Type to start grepping' | fzf \
        --layout=reverse \
        --disabled --ansi \
        --border=sharp \
        --delimiter : \
        --preview='bat --theme=moonlight-ansi --color=always -pp --highlight-line {2} {1}'\
        --preview-window '+{2}/2' \
        --bind "change:reload:rg --column --color=always {q} || :" \
        --bind "ctrl-x:become:echo 'vsplit {1} | {2}'"\
        --bind "ctrl-o:become:echo 'split {1} | {2}'"\
        --bind "enter:become:echo 'edit {1} | {2}'"
        ]])
    end,
    files = function()
        execute(default .. file_bind)
    end,
    buffers = function()
        execute(
            [[cat | fzf --layout=reverse \
        --border=sharp \
        --bind "enter:become:echo 'buffer {1}'"\
        --bind "ctrl-x:become:echo 'vnew | buffer {1}'"\
        --bind "ctrl-o:become:echo 'new | buffer {1}'"\
        ]],
            api.nvim_exec2("buffers", { output = true }).output
        )
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

bind("n", "<leader>r", "<cmd>Fzf oldfiles<cr>", { silent = true })
bind("n", "<leader>g", "<cmd>Fzf grep<cr>", { silent = true })
bind("n", "<leader>f", "<cmd>Fzf files<cr>", { silent = true })
bind("n", "<leader>b", "<cmd>Fzf buffers<cr>", { silent = true })
