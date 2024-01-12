-- terminal utils
local api, set = vim.api, vim.api.nvim_set_option_value
local M = {}
-- sessions:
-- {
--     [id] = {
--         buf: buffer number
--         cmd: command
--     }
-- }
M.sessions = {}
M.last = -1

local function change_term(offset)
    if not vim.bo.ft == "floatterm" then
        return
    end
    local buf = api.nvim_get_current_buf()
    for id, term in ipairs(M.sessions) do
        if term.buf == buf then
            local next_id = (id + offset) % #M.sessions
            if next_id == 0 then
                next_id = #M.sessions
            end
            vim.cmd("buffer " .. M.sessions[next_id].buf)
            M.last = next_id
            return
        end
    end
end

-- {
--     id: specify id (to restore)
--     new: force new terminal
--     cmd: command
-- }
local function open_term_win(buf)
    local w = api.nvim_open_win(buf, true, {
        relative = "editor",
        width = math.ceil(vim.o.co * 0.7),
        height = math.ceil(vim.o.lines * 0.75),
        row = (0.5 - 0.75 / 2) * vim.o.lines - 1,
        col = (0.5 - 0.7 / 2) * vim.o.co,
        style = "minimal",
        border = "single",
    })
    set("winhl", "Normal:TermBg", { win = w })
    set("scrolloff", 0, { win = w })
    set("filetype", "floatterm", { buf = buf })
end

local function create_new_term(cmd)
    local buf = api.nvim_create_buf(true, false)
    bind({ "t", "n" }, "gt", function()
        change_term(1)
    end, { buffer = buf })
    bind({ "t", "n" }, "gT", function()
        change_term(-1)
    end, { buffer = buf })
    open_term_win(buf)
    local id = #M.sessions + 1
    M.last = id
    M.sessions[id] = {
        buf = buf,
        cmd = cmd,
    }
    vim.opt_local.winbar = "  Term " .. id
    vim.fn.termopen(cmd, {
        -- or fish complains about too many envs
        clear_env = true,
        cwd = vim.fn.getcwd(),
        on_exit = function()
            -- if exited the indexing will be broken, but idk
            vim.cmd("bd %")
            M.last = -1
            table.remove(M.sessions, id)
        end,
    })
    vim.cmd.startinsert()
end

local function restore(id)
    local term = M.sessions[id]
    open_term_win(term.buf)
    vim.cmd.startinsert()
    M.last = id
end

M.open = function(opts)
    if opts.id then
        restore(opts.id)
        return
    end
    if not opts.new then
        if M.last > 0 then
            restore(M.last)
        else
            create_new_term(opts.cmd)
        end
    else
        create_new_term(opts.cmd)
    end
end

M.flip = function()

end


api.nvim_create_user_command("FloatTerm", function(opts)
    M.open({ new = opts.bang, cmd = vim.o.shell })
end, { nargs = 0, bang = true })

return M
