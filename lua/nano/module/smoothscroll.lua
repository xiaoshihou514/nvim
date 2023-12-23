-- Smooth scrolling for <C-d> and <C-u>
local scroll_win_id = -1
local interval = 12
local api = vim.api

local function smooth_scroll(key, getcount)
    if scroll_win_id ~= -1 then
        return
    end
    -- put a mark at where we started
    api.nvim_input("m'")
    scroll_win_id = api.nvim_get_current_win()
    local count = getcount(scroll_win_id)
    ---@diagnostic disable-next-line: undefined-field
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

bind({ "n", "x" }, "<C-d>", function()
    smooth_scroll("gj", function(win_id)
        return api.nvim_win_get_height(win_id) / 2
    end)
end, { noremap = true })

bind({ "n", "x" }, "<C-u>", function()
    smooth_scroll("gk", function(win_id)
        return api.nvim_win_get_height(win_id) / 2
    end)
end, { noremap = true })

bind({ "n", "x" }, "<C-f>", function()
    smooth_scroll("gj", function(win_id)
        return api.nvim_win_get_height(win_id)
    end)
end, { noremap = true })

bind({ "n", "x" }, "<C-b>", function()
    smooth_scroll("gk", function(win_id)
        return api.nvim_win_get_height(win_id)
    end)
end, { noremap = true })
