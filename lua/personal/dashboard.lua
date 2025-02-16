-- homemade dashboard, design completely stolen from dashboard-nvim's hyper theme
local api = vim.api
local ns = api.nvim_create_namespace("dashboard")
local project_shown = 5
local shown = 19
local header = {
    -- https://patorjk.com/software/taag/#p=display&f=Speed&t=NeoVim
    [[_____   __          ___    ______            ]],
    [[___  | / /____________ |  / /__(_)______ ___ ]],
    [[__   |/ /_  _ \  __ \_ | / /__  /__  __ `__ \]],
    [[_  /|  / /  __/ /_/ /_ |/ / _  / _  / / / / /]],
    [[/_/ |_/  \___/\____/_____/  /_/  /_/ /_/ /_/ ]],
}
local patterns = root_patterns
local shortcuts = {
    {
        desc = " Recent",
        key = "r",
        action = function()
            api.nvim_command("Fzf oldfiles")
        end,
    },
    {
        desc = " Config",
        key = "c",
        action = function()
            vim.cmd.lcd("~/.config/nvim")
            api.nvim_command("Fzf files")
        end,
    },
    {
        desc = "󰠮 Notes",
        key = "N",
        action = function()
            vim.cmd.lcd("~/Documents/notes")
            api.nvim_command("Fzf files")
        end,
    },
    {
        desc = " Projects",
        key = "p",
        action = function()
            local base = vim.env.HOME .. "/Playground/"
            local items = vim.iter(vim.fn.uniq(vim.fs.find(patterns, {
                path = base,
                type = "directory",
                limit = math.huge,
            })))
                :map(function(path)
                    return path:sub(1, -6)
                end)
                :totable()
            vim.ui.select(items, {
                prompt = "Projects",
                format_item = function(path)
                    local split = vim.split(path, "/")
                    return "  " .. split[#split]
                end,
            }, function(item)
                if not item then
                    return
                end
                vim.cmd.lcd(item)
                api.nvim_command("Fzf files")
            end)
        end,
    },
    { desc = "󰿅 Quit", key = "q", action = vim.cmd.quit },
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
        bufhidden = "wipe",
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

-- init
if vim.bo.ft == "lazy" then
    vim.cmd.quit()
end
local buf = api.nvim_create_buf(false, true)
local win = api.nvim_get_current_win()
api.nvim_win_set_buf(win, buf)
set_opts()
local buftext = vim.deepcopy(header)
local hls = {}
local disabled = {
    "w",
    "f",
    "b",
    "h",
    "j",
    "k",
    "l",
    "<Up>",
    "<Down>",
    "<Left>",
    "<Right>",
    "<Enter>",
}
vim.tbl_map(function(k)
    bind(k, "<Nop>")
end, disabled)

-- header
for i, l in ipairs(header) do
    table.insert(hls, { "DashboardHeader", i - 1, 0, -1 })
    buftext[i] = get_pad(l) .. l
end

-- nvim version
table.insert(buftext, "")
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
    local rhs = btn.action
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
local files = vim.tbl_filter(function(f)
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
local match = 0
local maxlen = 0
-- get directories
local projects = {}
for _, file in ipairs(files) do
    if match >= project_shown then
        break
    end
    for _, p in ipairs(patterns) do
        local result = vim.fs.find(p, { path = file, upward = true, stop = vim.env.HOME })
        if not vim.tbl_isempty(result) then
            local matched = vim.fs.dirname(result[1]):gsub(vim.env.HOME, "~")
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
    table.insert(buftext, file_pad .. proj .. string.rep("·", maxlen - #proj) .. key)
    table.insert(
        hls,
        { "Comment", #buftext - 1, #file_pad + #proj, #file_pad + 2 * maxlen - #proj - 1 }
    )
    table.insert(hls, {
        "DashboardShortCut",
        #buftext - 1,
        #file_pad + 2 * maxlen - #proj,
        #file_pad + 2 * maxlen - #proj + 1,
    })
    bind(key, function()
        vim.cmd.lcd(proj)
        api.nvim_command("Fzf files")
    end)
    count = count + 1
end
table.insert(buftext, "")
for _, file in ipairs(recent) do
    local key = keys:sub(count, count)
    table.insert(buftext, file_pad .. file .. string.rep("·", maxlen - #file) .. key)
    table.insert(
        hls,
        { "Comment", #buftext - 1, #file_pad + #file, #file_pad + 2 * maxlen - #file - 1 }
    )
    table.insert(hls, {
        "DashboardShortCut",
        #buftext - 1,
        #file_pad + 2 * maxlen - #file,
        #file_pad + 2 * maxlen - #file + 1,
    })
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
    vim.hl.range(buf, ns, hl[1], { hl[2], hl[3] }, { hl[2], hl[4] })
end, hls)
api.nvim_set_option_value("modifiable", false, { buf = 0 })
