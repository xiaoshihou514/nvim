local api = vim.api
local pairs = {
    { "(", ")" },
    { "[", "]" },
    { "{", "}" },
    { "<", ">" },
    { '"', '"' },
    { "'", "'" },
}
local asymmetric_pairs = {
    { "(", ")" },
    { "[", "]" },
    { "{", "}" },
}

-- local variables, yeah
local prev_pos, op

-- only works for single line
_G._surround = function()
    local cur_line = api.nvim_get_current_line()
    local pos = api.nvim_buf_get_mark(0, "[")
    if vim.deep_equal(pos, { 0, 0 }) then
        -- mark is not set
        return
    end
    local row, left = unpack(pos)
    pos = api.nvim_buf_get_mark(0, "]")
    if vim.deep_equal(pos, { 0, 0 }) then
        return
    end
    local row_, right = unpack(pos)
    -- too lazy to deal with this case
    if row ~= row_ then
        return
    end
    local prefix = cur_line:sub(1, left - 1)
    local inner = cur_line:sub(left + 1, right + 1)
    local postfix = cur_line:sub(right + 3, -1)
    if op == "delete" then
        -- we deleted a char
        prev_pos[2] = prev_pos[2] - 1
        api.nvim_buf_set_lines(0, row - 1, row, true, { prefix .. inner .. postfix })
    elseif op == "change" then
        local input = vim.fn.getcharstr()
        local replacement = { input, input }
        -- look for predefined pairs
        for _, pair in ipairs(pairs) do
            if pair[1] == input or pair[2] == input then
                replacement = pair
                break
            end
        end
        -- else assume they are the same
        api.nvim_buf_set_lines(
            0,
            row - 1,
            row,
            true,
            { prefix .. replacement[1] .. inner .. replacement[2] .. postfix }
        )
    end
    -- restore cursor pos
    api.nvim_win_set_cursor(0, prev_pos)
    prev_pos = nil
    op = nil
end

bind("n", "ds", function()
    -- get ourselves into operator pending mode
    api.nvim_set_option_value("operatorfunc", "v:lua._surround", {})
    op = "delete"
    prev_pos = api.nvim_win_get_cursor(0)
    return "g@i"
end, { expr = true })

bind("n", "cs", function()
    -- get ourselves into operator pending mode
    api.nvim_set_option_value("operatorfunc", "v:lua._surround", {})
    op = "change"
    prev_pos = api.nvim_win_get_cursor(0)
    return "g@i"
end, { expr = true })