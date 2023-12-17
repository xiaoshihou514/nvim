-- terminal utils
local api, set = vim.api, vim.api.nvim_set_option_value
local M = {}
-- scratch_sessions:
-- {
--     [id] = {
--         buf: buffer number
--         cmd: command
--     }
-- }
M.scratch_sessions = {}
M.last = -1

local function change_term(offset)
    if not vim.bo.ft == "floatterm" then
        return
    end
    local buf = api.nvim_get_current_buf()
    for id, term in ipairs(M.scratch_sessions) do
        if term.buf == buf then
            local next_id = (id + offset) % #M.scratch_sessions
            if next_id == 0 then
                next_id = #M.scratch_sessions
            end
            vim.cmd("buffer " .. M.scratch_sessions[next_id].buf)
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
    local id = #M.scratch_sessions + 1
    M.last = id
    M.scratch_sessions[id] = {
        buf = buf,
        cmd = cmd,
    }
    vim.fn.termopen(cmd, {
        cwd = vim.fn.getcwd(),
        on_exit = function()
            -- if exited the indexing will be broken, but idk
            vim.cmd("bd %")
            M.last = -1
            M.scratch_sessions[id] = nil
        end,
    })
    vim.cmd.startinsert()
end

local function restore(id)
    local term = M.scratch_sessions[id]
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

api.nvim_create_user_command("Flip", function(opts)
    M.flip()
end, { nargs = 0 })
return M
