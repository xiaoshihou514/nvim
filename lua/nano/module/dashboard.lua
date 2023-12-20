-- homemade dashboard, design completely stolen from dashboard-nvim's hyper theme
local api = vim.api
local ns = api.nvim_create_namespace("dashboard")
local project_shown = 5
local shown = 19
local header = {
    [[_____   __                 _____            ]],
    [[___  | / /_____________   ____(_)______ ___ ]],
    [[__   |/ /_  _ \  __ \_ | / /_  /__  __ `__ \]],
    [[_  /|  / /  __/ /_/ /_ |/ /_  / _  / / / / /]],
    [[/_/ |_/  \___/\____/_____/ /_/  /_/ /_/ /_/ ]],
    [[                                            ]],
}
local shortcuts = {
    { desc = " Recent", key = "r", action = "Telescope oldfiles" },
    { desc = "󰏗 Plugins", key = "P", action = "NanoPack" },
    {
        desc = " Config",
        key = "c",
        action = function()
            require("telescope.builtin").find_files({ cwd = "~/.config/nanovim" })
        end,
    },
    {
        desc = " Projects",
        key = "p",
        action = function()
            local patterns = {
                ".git",
                "lazy-lock.json",
                "Cargo.toml",
                "*.cabal",
                "go.mod",
                "CMakeList.txt",
                "package.json",
            }
            local base = vim.env.HOME .. "/Playground/"
            local items = vim.iter(vim.fn.uniq(
                vim.fs.find(patterns, {
                    path = base,
                    type = "directory",
                    limit = math.huge,
                }))):map(function(path)
                return path:sub(1, -6)
            end):totable()
            vim.ui.select(items, {
                prompt = "Projects",
                format_item = function(path)
                    local split = vim.split(path, "/")
                    return "  " .. split[#split]
                end
            }, function(item)
                if not item then return end
                require("telescope.builtin").find_files({ cwd = item })
            end)
        end
    },
    { desc = "󰿅 Quit", key = "q", action = "q" },
}
local footer = {
    [[                                  ]],
    [[Ah mais! Ça ne finira donc jamais?]],
}

local function get_pad(str)
    return string.rep(" ", (vim.o.columns - #str) / 2)
end

local function set_opts()
    local opts = {
        bufhidden = "delete",
        colorcolumn = "",
        foldcolumn = "0",
        matchpairs = "",
        buflisted = false,
        cursorcolumn = false,
        cursorline = false,
        list = false,
        number = false,
        relativenumber = false,
        spell = false,
        swapfile = false,
        readonly = false,
        filetype = "dashboard",
        wrap = false,
        signcolumn = "no",
        winbar = " ",
    }
    for opt, val in pairs(opts) do
        vim.opt_local[opt] = val
    end
end

local bind = function(lhs, rhs)
    bind("n", lhs, rhs, { buffer = 0 })
end

return function(load_time)
    -- init
    local buf = api.nvim_create_buf(false, true)
    local win = api.nvim_get_current_win()
    api.nvim_win_set_buf(win, buf)
    set_opts()
    local buftext = vim.deepcopy(header)
    local hls = {}
    local disabled =
    { "w", "f", "b", "h", "j", "k", "l", "<Up>", "<Down>", "<Left>", "<Right>", "<Enter>" }
    vim.tbl_map(function(k)
        bind(k, "<Nop>")
    end, disabled)

    -- header
    for i, l in ipairs(header) do
        table.insert(hls, { "DashboardHeader", i - 1, 0, -1 })
        buftext[i] = get_pad(l) .. l
    end

    -- plugin info, nvim version
    local startuptime = ("neovim loaded in %sms"):format(load_time)
    table.insert(buftext, get_pad(startuptime) .. startuptime)
    table.insert(hls, { "Comment", #buftext - 1, 0, -1 })
    local ver = vim.version()
    local version = "NVIM v"
    version = string.format("%s%s.%s.%s", version, ver.major, ver.minor, ver.patch)
    if ver.prerelease then
        version = string.format("%s-%s-%s", version, ver.prerelease, ver.build)
    end
    table.insert(buftext, get_pad(version) .. version)
    table.insert(hls, { "Comment", #buftext - 1, 0, -1 })

    -- buttons
    local buttons = ""
    for _, btn in ipairs(shortcuts) do
        buttons = string.format("%s%s [%s]  ", buttons, btn.desc, btn.key)
        local rhs = type(btn.action) == "string" and ("<cmd>%s<cr>"):format(btn.action) or btn.action
        bind(btn.key, rhs)
    end
    buttons = buttons:sub(0, -3)
    local btn_pad = get_pad(buttons) .. string.rep(" ", #shortcuts) -- due to nerd font issues I think
    table.insert(buftext, btn_pad .. buttons)
    local col = #btn_pad
    for _, btn in ipairs(shortcuts) do
        table.insert(hls, { "DashboardShortcut", #buftext - 1, col, col + #btn.desc })
        col = col + #btn.desc + 6
    end

    -- recent files and directories
    table.insert(buftext, "")
    local files = vim.v.oldfiles
    files = vim.tbl_filter(function(f)
        -- is a file, not a help file, and not in /tmp
        return vim.uv.fs_stat(f)
            and not f:match("/share/nvim/runtime/")
            and not f:match("^/tmp")
    end, files)
    local match = 0
    local maxlen = 0
    local patterns = {
        ".git",
        "lazy-lock.json",
        "Cargo.toml",
        "*.cabal",
        "go.mod",
        "CMakeList.txt",
        "package.json",
    }
    -- get directories
    local projects = {}
    for _, file in ipairs(files) do
        if match >= project_shown then
            break
        end
        local dir = file:match("(.*)/")
        for _, p in ipairs(patterns) do
            local result = vim.fs.find(p, { path = dir, upward = true, stop = vim.env.HOME })
            if not vim.tbl_isempty(result) then
                local matched = (result[1]):match("(.*)/"):gsub(vim.env.HOME, "~")
                if not vim.tbl_contains(projects, matched) and matched ~= "~" then
                    table.insert(projects, matched)
                    if #matched > maxlen then
                        maxlen = #matched
                    end
                    match = match + 1
                end
            end
        end
    end
    local recent, i = {}, 1
    while #recent < shown - match and i < #files do
        local f = files[i]:gsub(vim.env.HOME, "~")
        if #f > maxlen then
            maxlen = #f
        end
        if f ~= "~" then
            table.insert(recent, f)
        end
        i = i + 1
    end
    -- padding
    maxlen = maxlen + 2
    local file_pad = string.rep(" ", (vim.o.co - maxlen) / 2)
    local keys = "asdfjklgehwbnmyuiovtxz"
    -- add
    local pos = { #buftext + 1, #file_pad }
    local count = 1
    for _, proj in ipairs(projects) do
        local key = keys:sub(count, count)
        table.insert(buftext, file_pad .. proj .. string.rep(" ", maxlen - #proj) .. key)
        table.insert(
            hls,
            { "DashboardShortCut", #buftext - 1, #file_pad + maxlen, #file_pad + maxlen + 1 }
        )
        bind(key, function()
            require("telescope.builtin").find_files({ cwd = proj })
        end)
        count = count + 1
    end
    table.insert(buftext, "")
    for _, file in ipairs(recent) do
        local key = keys:sub(count, count)
        table.insert(buftext, file_pad .. file .. string.rep(" ", maxlen - #file) .. key)
        table.insert(
            hls,
            { "DashboardShortCut", #buftext - 1, #file_pad + maxlen, #file_pad + maxlen + 1 }
        )
        bind(key, "<cmd>edit " .. file .. "<cr>")
        count = count + 1
    end

    -- footer
    for _, l in ipairs(footer) do
        table.insert(buftext, get_pad(l) .. l)
        table.insert(hls, { "DashboardFooter", #buftext - 1, 0, -1 })
    end

    -- apply
    api.nvim_buf_set_lines(buf, 0, -1, false, buftext)
    api.nvim_win_set_cursor(win, pos)
    vim.tbl_map(function(hl)
        api.nvim_buf_add_highlight(buf, ns, hl[1], hl[2], hl[3], hl[4])
    end, hls)
    vim.opt_local.modifiable = false
end
