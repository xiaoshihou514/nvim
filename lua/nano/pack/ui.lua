local M = { state = nil }

local api = vim.api
local set = vim.api.nvim_set_option_value

function M.update_state(state)
    M.state = state
end

function M.show(state)
    local buf = api.nvim_create_buf(true, false)
    local w = api.nvim_open_win(buf, true, {
        relative = "editor",
        width = math.ceil(vim.o.co * 0.7),
        height = math.ceil(vim.o.lines * 0.75),
        row = (0.5 - 0.75 / 2) * vim.o.lines - 1,
        col = (0.5 - 0.7 / 2) * vim.o.co,
        style = "minimal",
        border = "single",
    })
    set("number", false, { win = w })
    set("relativenumber", false, { win = w })
    set("winhl", "Normal:TermBg", { win = w })
    set("scrolloff", 0, { win = w })
    set("filetype", "floatterm", { buf = buf })
end

function M.sync_and_close()
    -- TODO
end

function M.sync()
    -- TODO
end

function M.overview()
    -- TODO
end

return M
