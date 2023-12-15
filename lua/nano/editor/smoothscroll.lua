-- Smooth scrolling for <C-d> and <C-u>
local scroll_win_id = -1
local interval = 12
local api = vim.api
local function smooth_scroll(key, getcount)
    if scroll_win_id ~= -1 then
        return
    end
    scroll_win_id = api.nvim_get_current_win()
    local count = getcount(scroll_win_id)
    local timer = vim.uv.new_timer()
    local function scroll_callback()
        if count > 0 and api.nvim_get_current_win() == scroll_win_id then
            api.nvim_input(key)
            count = count - 1
        else
            scroll_win_id = -1
            if not timer:is_closing() then
                timer:close()
            end
        end
    end
    timer:start(interval, interval, vim.schedule_wrap(scroll_callback))
    timer:set_repeat(interval)
end

local function cj()
    smooth_scroll("gj", function(win_id)
        return api.nvim_win_get_height(win_id) / 2
    end)
end
local function ck()
    smooth_scroll("gk", function(win_id)
        return api.nvim_win_get_height(win_id) / 2
    end)
end
vim.keymap.set({ "n", "x" }, "<C-d>", cj, { noremap = true })
vim.keymap.set({ "n", "x" }, "<C-u>", ck, { noremap = true })
