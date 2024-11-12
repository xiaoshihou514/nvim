---@diagnostic disable: undefined-field
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
    "--git-ignore",
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
local ns = api.nvim_create_namespace("Dired")
local getcwd = vim.fn.getcwd

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
    local cwd = getcwd()
    local full_path = vim.fs.joinpath(cwd, file)
    return full_path, line:sub(1, 1)
end

local function refresh(dir)
    dir = dir or getcwd()
    local buf = api.nvim_create_buf(false, true)
    api.nvim_win_set_buf(0, buf)
    api.nvim_command("lcd " .. dir)
    vim.bo[buf].ft = "dired"
end

local function ask(prompt, cb)
    vim.ui.input({ prompt = prompt }, function(confirm)
        if confirm ~= "y" then
            vim.cmd.enew()
            return
        end
        cb()
    end)
end

local function disable(mode, key)
    bind(mode, key, "<Nop>", { buffer = true })
end

local function system(cmd, cwd, view, errormsg, f)
    vim.system(
        cmd,
        {
            cwd = cwd,
        },
        vim.schedule_wrap(function(status)
            if status.code ~= 0 then
                vim.notify(errormsg, 3)
            end
            if f and type(f) == "function" then
                f()
            end
            refresh()
            vim.defer_fn(function()
                vim.fn.winrestview(view)
            end, 10)
        end)
    )
end

-- quit
bind("n", "q", vim.cmd.quit, { buffer = true })
bind("n", "<Esc>", vim.cmd.quit, { buffer = true })

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
end, { buffer = true })

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
end, { buffer = true })

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
end, { buffer = true })

-- goto parent
bind("n", "-", function()
    refresh(vim.fs.dirname(getcwd()))
end, { buffer = true })

-- toggle hidden
bind("n", "h", function()
    vim.g.dired_show_hidden = not vim.g.dired_show_hidden
    refresh()
end, { buffer = true })

-- rename
bind("n", "r", function()
    local selected, _ = get_selected()
    if not selected then
        return
    end
    local cwd = getcwd()
    local view = api.nvim_win_call(0, vim.fn.winsaveview)
    vim.ui.input({
        prompt = "Rename to:",
        default = selected,
    }, function(input)
        if not input then
            return
        end
        if vim.uv.fs_stat(input) then
            ask('Overwrite "' .. input .. '"?', function()
                system(
                    { "/bin/mv", selected, input },
                    cwd,
                    view,
                    "Rename failed",
                    function()
                        for _, buf in ipairs(api.nvim_list_bufs()) do
                            if api.nvim_buf_get_name(buf) == input then
                                api.nvim_buf_call(buf, function()
                                    vim.cmd("edit! " .. input)
                                end)
                            end
                        end
                    end
                )
            end)
        else
            system({ "/bin/mv", selected, input }, cwd, view, "Rename failed")
        end
        -- HACK: command window exists if not so
        vim.cmd.enew()
    end)
end, { buffer = true })

-- select
bind("n", "<Tab>", function()
    local selected, _ = get_selected()
    if not selected then
        return
    end

    vim.g.dired_selected = vim.g.dired_selected or {}
    local idx = vim.fn.index(vim.g.dired_selected, selected)
    local temp = vim.g.dired_selected
    if idx < 0 then
        -- add to selection
        table.insert(temp, selected)

        local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
        api.nvim_buf_set_extmark(0, ns, row - 1, 0, {
            end_col = #api.nvim_get_current_line(),
            hl_group = "Visual",
        })
    else
        -- remove from selection
        table.remove(temp, idx + 1)

        local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
        local extmark =
            api.nvim_buf_get_extmarks(0, ns, { row - 1, 0 }, { row + 1, 0 }, {})[1]
        api.nvim_buf_del_extmark(0, ns, extmark[1])
    end
    vim.g.dired_selected = temp
end, { buffer = true })

-- move
bind("n", "m", function()
    local cwd = getcwd()
    local view = api.nvim_win_call(0, vim.fn.winsaveview)
    if not vim.g.dired_selected or vim.tbl_isempty(vim.g.dired_selected) then
        return
    end
    for _, f in ipairs(vim.g.dired_selected) do
        local to = vim.fs.joinpath(cwd, vim.fn.fnamemodify(f, ":t"))
        if vim.uv.fs_stat(to) then
            ask('Overwrite "' .. to .. '"?', function()
                system(
                    { "/bin/mv", f, to },
                    cwd,
                    view,
                    ("Move failed: mv %s %s"):format(f, to)
                )
            end)
        else
            system(
                { "/bin/mv", f, to },
                cwd,
                view,
                ("Move failed: mv %s %s"):format(f, to)
            )
        end
    end
    vim.g.dired_selected = {}
end, { buffer = true })

-- create
bind("n", "c", function()
    local cwd = getcwd()
    local view = api.nvim_win_call(0, vim.fn.winsaveview)
    vim.ui.input({
        prompt = "Create:",
        default = cwd .. "/",
    }, function(input)
        if not input then
            return
        end
        if vim.uv.fs_stat(input) then
            vim.notify(input .. " already exists", 4)
            return
        end
        if input:sub(#input, #input) == "/" then
            system(
                { "mkdir", "-p", input },
                cwd,
                view,
                "Failed to create directory " .. input
            )
        else
            system({ "touch", input }, cwd, view, "Failed to create file " .. input)
        end
        -- HACK: command window exists if not so
        vim.cmd.enew()
    end)
end, { buffer = true })

-- delete
bind("n", "d", function()
    local cwd = getcwd()
    local view = api.nvim_win_call(0, vim.fn.winsaveview)
    if not vim.g.dired_selected or vim.tbl_isempty(vim.g.dired_selected) then
        return
    end
    local tostr = table.concat(vim.g.dired_selected, ", ")
    local cmd = vim.g.dired_selected
    table.insert(cmd, 1, "-rf")
    table.insert(cmd, 1, "rm")
    ask("Remove " .. tostr .. "?", function()
        system(cmd, cwd, view, ("Deletion failed: rm -rf %s"):format(tostr))
        vim.g.dired_selected = {}
        vim.cmd.enew()
    end)
end, { buffer = true })

-- paste
bind("n", "p", function()
    local cwd = getcwd()
    local view = api.nvim_win_call(0, vim.fn.winsaveview)
    if not vim.g.dired_selected or vim.tbl_isempty(vim.g.dired_selected) then
        return
    end
    for _, f in ipairs(vim.g.dired_selected) do
        local to = vim.fs.joinpath(cwd, vim.fn.fnamemodify(f, ":t"))
        if vim.uv.fs_stat(to) then
            ask('Overwrite "' .. to .. '"?', function()
                system(
                    { "/bin/cp", "-rf", f, to },
                    cwd,
                    view,
                    ("Copy failed: cp %s %s"):format(f, to)
                )
            end)
        else
            system(
                { "/bin/cp", "-rf", f, to },
                cwd,
                view,
                ("Copy failed: cp %s %s"):format(f, to)
            )
        end
    end
    vim.g.dired_selected = {}
end, { buffer = true })

bind("n", "G", function()
    api.nvim_feedkeys("gg", "n", false)
    local count = 0
    for _, l in ipairs(api.nvim_buf_get_lines(0, 0, -1, false)) do
        if l == "" then
            break
        end
        count = count + 1
    end
    api.nvim_feedkeys(count - 1 .. "gj", "n", false)
end, { buffer = true })

bind("n", "/", function()
    local target = vim.fn.getcwd()
    vim.cmd.quit()
    local save = vim.fn.getcwd()
    vim.cmd.lcd(target)
    vim.cmd("Fzf files-cwd")
    vim.cmd.lcd(save)
end, { buffer = true })

disable("n", "i")
disable("n", "a")
disable("n", "A")
disable("t", "<Esc>")
disable("t", "l")

local cwd = getcwd()
vim.schedule(function()
    vim.fn.termopen(vim.g.dired_show_hidden and eza_cmd_with_hidden or eza_cmd, {
        cwd = cwd,
        on_exit = function()
            vim.cmd([[syntax match ExitCode "\[Process exited \d\+\]" conceal]])
            -- hl selected files
            for row, line in ipairs(api.nvim_buf_get_lines(0, 0, -1, false)) do
                local name, _ = get_file(line)
                local f = vim.fs.joinpath(cwd, name)
                if vim.fn.index(vim.g.dired_selected or {}, f) >= 0 then
                    api.nvim_buf_set_extmark(0, ns, row - 1, 0, {
                        end_col = #line,
                        hl_group = "Visual",
                    })
                end
            end
        end,
    })
end)
