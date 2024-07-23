local api = vim.api

local opts = {
    number = false,
    relativenumber = false,
    spell = false,
    scrolloff = 0,
    winbar = "%=%{v:lua.vim.fn.getcwd()}%=",
    conceallevel = 2,
    concealcursor = "nc",
}

for opt, val in pairs(opts) do
    api.nvim_set_option_value(opt, val, { win = 0 })
end

local eza_cmd = {
    "eza",
    "--group-directories-first",
    "--icons=always",
    "--color=always",
    "--git",
    "--long",
}
local eza_cmd_with_hidden = {
    "eza",
    "--group-directories-first",
    "--icons=always",
    "--color=always",
    "--git",
    "--all",
    "--long",
}
local this = api.nvim_get_current_buf()

local function get_file(line)
    local file_patt_git = "%S+%s+%S+%s+%S+%s+%S+%s+%S+%s+%S+%s+%S+%s+%S+%s+(.+)"
    local file_patt = "%S+%s+%S+%s+%S+%s+%S+%s+%S+%s+%S+%s+%S+%s+(.+)"
    local file = line:match(file_patt_git) or line:match(file_patt)
    if not file then
        return nil
    end
    if file:match("'.*'") then
        file = file:sub(2, -2)
    end
    return file
end

local function get_selected()
    local line = api.nvim_get_current_line()
    local file = get_file(line)
    if not file then
        return nil, nil
    end
    local cwd = vim.fn.getcwd()
    local full_path = vim.fs.joinpath(cwd, file)
    return full_path, line:sub(1, 1)
end

local function refresh(dir)
    dir = dir or vim.fn.getcwd()
    local buf = api.nvim_create_buf(false, true)
    api.nvim_win_set_buf(0, buf)
    api.nvim_command("lcd " .. dir)
    vim.bo[buf].ft = "dired"
end

local function action(cmd, cwd, from, to, view)
    vim.system(
        { cmd, from, to },
        {
            cwd = cwd,
        },
        vim.schedule_wrap(function(status)
            if status.code ~= 0 then
                vim.notify("Rename failed", 3)
            end
            api.nvim_command("Dired " .. cwd)
            vim.defer_fn(function()
                vim.fn.winrestview(view)
            end, 10)
        end)
    )
end

local function ask(prompt, cb)
    vim.ui.input({ prompt = prompt }, function(confirm)
        if confirm ~= "y" then
            return
        end
        cb()
    end)
end

-- quit
bind("n", "q", vim.cmd.quit, { buffer = this })

-- open here
bind("n", "<cr>", function()
    local selected, tp = get_selected()
    if not selected then
        return
    end
    if tp == "." then
        -- file
        api.nvim_command("silent! quit!")
        api.nvim_command("edit " .. selected)
    else
        -- directory
        refresh(selected)
    end
end, { buffer = this })

-- open in vsplit
bind("n", "<C-x>", function()
    local selected, tp = get_selected()
    if not selected then
        return
    end
    if tp == "." then
        -- file
        api.nvim_command("silent! quit!")
        api.nvim_command("vsplit " .. selected)
    end
end)

-- open in split
bind("n", "<C-o>", function()
    local selected, tp = get_selected()
    if not selected then
        return
    end
    if tp == "." then
        -- file
        api.nvim_command("silent! quit!")
        api.nvim_command("split " .. selected)
    end
end)

-- goto parent
bind("n", "-", function()
    refresh(vim.fs.dirname(vim.fn.getcwd()))
end, { buffer = this })

-- toggle hidden
bind("n", "h", function()
    vim.g.dired_show_hidden = not vim.g.dired_show_hidden
    refresh()
end, { buffer = this })

-- rename
bind("n", "r", function()
    local selected, _ = get_selected()
    if not selected then
        return
    end
    local cwd = vim.fn.getcwd()
    local view = api.nvim_win_call(0, vim.fn.winsaveview)
    vim.ui.input({
        prompt = "Rename to:",
        default = selected,
    }, function(input)
        if not input then
            return
        end
        if vim.uv.fs_stat(input) then
            ask("Overwrite " .. input .. "?", function()
                action("mv", cwd, selected, input, view)
            end)
        else
            action("mv", cwd, selected, input, view)
        end
    end)
end, { buffer = this })

-- select
bind("n", "<Tab>", function()
    -- TODO
end, { buffer = this })

-- move
bind("n", "m", function()
    -- TODO
end, { buffer = this })

-- create
bind("n", "c", function()
    -- TODO
end, { buffer = this })

-- delete
bind("n", "d", function()
    -- TODO
end, { buffer = this })

-- yank
bind("n", "y", function()
    -- TODO
end, { buffer = this })

-- paste
bind("n", "p", function()
    -- TODO
end, { buffer = this })

bind("n", "i", "<Nop>", { buffer = this })
bind("n", "a", "<Nop>", { buffer = this })
bind("n", "A", "<Nop>", { buffer = this })

vim.schedule(function()
    vim.fn.termopen(vim.g.dired_show_hidden and eza_cmd_with_hidden or eza_cmd, {
        cwd = vim.fn.getcwd(),
        on_exit = function()
            vim.cmd([[syntax match ExitCode "\[Process exited \d\+\]" conceal]])
        end,
    })
end)
