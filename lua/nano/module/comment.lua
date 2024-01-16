local api = vim.api

local function get_cstr()
    local cstr_raw = vim.bo.commentstring
    if cstr_raw == "" then
        return cstr_raw
    end
    -- "-- %s" -> "--", "//%s" -> "//"
    cstr_raw = cstr_raw:match("(.-)%s*%%s")
    local cstr = ""
    -- escape everything
    for i = 1, #cstr_raw do
        cstr = cstr .. "%" .. cstr_raw:sub(i, i)
    end
    return cstr_raw, cstr
end

_G._comment_linewise = function()
    local cstr_raw, cstr = get_cstr()
    if not cstr then return end
    local cur_line = api.nvim_get_current_line()
    local row = api.nvim_win_get_cursor(0)[1] - 1
    local pattern = "^(%s*)" .. cstr .. " (.*)$"
    local spaces, line = cur_line:match(pattern)
    if spaces and line then
        -- is already a comment
        api.nvim_buf_set_lines(0, row, row + 1, true, { spaces .. line })
    else
        -- get spaces and rest of line
        spaces, line = cur_line:match("^(%s*)(.*)$")
        api.nvim_buf_set_lines(0, row, row + 1, true, { spaces .. cstr_raw .. " " .. line })
    end
end

bind("n", "gcc", function()
    -- dot repeat magic :D
    api.nvim_set_option_value("operatorfunc", "v:lua._comment_linewise", {})
    return "g@l"
end, { expr = true })

bind("x", "gc", function()
    local start = vim.fn.getpos('v')[2] - 1
    local finish = vim.fn.getpos('.')[2] - 1
    local cstr_raw, cstr = get_cstr()
    local pattern = "^(%s*)" .. cstr .. " (.*)$"
    if not cstr then return end
    for row = start, finish do
        local cur_line = api.nvim_buf_get_lines(0, row, row + 1, true)[1]
        local spaces, line = cur_line:match(pattern)
        if spaces and line then
            -- is already a comment
            api.nvim_buf_set_lines(0, row, row + 1, true, { spaces .. line })
        else
            -- get spaces and rest of line
            spaces, line = cur_line:match("^(%s*)(.*)$")
            api.nvim_buf_set_lines(0, row, row + 1, true, { spaces .. cstr_raw .. " " .. line })
        end
    end
end)
