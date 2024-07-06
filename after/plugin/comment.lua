local api = vim.api

local function get_cstr()
    local cstr_raw = vim.bo.commentstring
    if cstr_raw == "" then
        return
    end
    -- "-- %s" -> "-- " nil, "//%s" -> "// " nil
    -- "<!--  %s-->" -> "<!-- ", " -->"
    local cstr_left, cstr_right = cstr_raw:match("(.-)%s*%%s%s*(.-)$")
    local cstr_left_pattern, cstr_right_pattern = "", ""
    -- escape everything
    for i = 1, #cstr_left do
        cstr_left_pattern = cstr_left_pattern .. "%" .. cstr_left:sub(i, i)
    end
    cstr_left = cstr_left .. " "
    cstr_left_pattern = cstr_left_pattern .. "[ ]?"
    if not cstr_right or cstr_right == "" then
        return cstr_left, cstr_left_pattern, nil, nil
    end
    for i = 1, #cstr_right do
        cstr_right_pattern = cstr_right_pattern .. "%" .. cstr_right:sub(i, i)
    end
    cstr_right = " " .. cstr_right
    cstr_right_pattern = cstr_right_pattern .. "[ ]?"
    return cstr_left, cstr_left_pattern, cstr_right, cstr_right_pattern
end

local function make_comment_pattern(cl_p, cr_p)
    -- pre: comment is prefixed and postfixed with one space
    if not cr_p then
        return "^(%s*)" .. cl_p .. "(.-)$"
    end
    return "^(%s*)" .. cl_p .. "(.-)" .. cr_p .. "%s*$"
end

_G._comment_linewise = function()
    local cl, cl_p, cr, cr_p = get_cstr()
    if not cl then
        return
    end
    local cur_line = api.nvim_get_current_line()
    local row = api.nvim_win_get_cursor(0)[1] - 1
    local pattern = make_comment_pattern(cl_p, cr_p)
    local spaces, line = cur_line:match(pattern)
    if spaces and line then
        -- is already a comment
        api.nvim_buf_set_lines(0, row, row + 1, true, { spaces .. line })
    else
        -- not a comment, get spaces and rest of line
        spaces, line = cur_line:match("^(%s*)(.-)$")
        api.nvim_buf_set_lines(0, row, row + 1, true, { spaces .. cl .. line .. (cr or "") })
    end
end

bind("n", "<leader>c", function()
    -- dot repeat magic :D
    api.nvim_set_option_value("operatorfunc", "v:lua._comment_linewise", {})
    return "g@l"
end, { expr = true })

bind("x", "<leader>c", function()
    local start = vim.fn.getpos("v")[2] - 1
    local finish = vim.fn.getpos(".")[2] - 1
    start, finish = math.min(start, finish), math.max(start, finish)
    local cl, cl_p, cr, cr_p = get_cstr()
    if not cl then
        return
    end
    local pattern = make_comment_pattern(cl_p, cr_p)
    -- no one would have a file with 256 indents
    local total_count, comment_count, min_spaces = 0, 0, 256
    -- we try to guess user's intent
    for row = start, finish do
        local cur_line = api.nvim_buf_get_lines(0, row, row + 1, true)[1]
        if cur_line == "" then
            goto continue
        end
        total_count = total_count + 1
        local spaces, line = cur_line:match(pattern)
        if spaces and line then
            -- is a comment
            comment_count = comment_count + 1
        else
            spaces, line = cur_line:match("^(%s*)(.-)$")
        end
        if #spaces < min_spaces then
            min_spaces = #spaces
        end
        ::continue::
    end
    local spaces = string.rep(" ", min_spaces)
    if comment_count ~= total_count then
        -- not all comments, we want to comment these lines
        for row = start, finish do
            local cur_line = api.nvim_buf_get_lines(0, row, row + 1, true)[1]
            -- we will leave empty lines as is
            if cur_line ~= "" then
                local line_spaces, line = cur_line:match("^(%s*)(.-)$")
                api.nvim_buf_set_lines(
                    0,
                    row,
                    row + 1,
                    true,
                    { spaces .. cl .. string.rep(" ", #line_spaces - min_spaces) .. line .. (cr or "") }
                )
            end
        end
    else
        -- all comments, will uncomment all
        for row = start, finish do
            local cur_line = api.nvim_buf_get_lines(0, row, row + 1, true)[1]
            if cur_line ~= "" then
                local spaces, line = cur_line:match(pattern)
                api.nvim_buf_set_lines(0, row, row + 1, true, { spaces .. line })
            end
        end
    end
end)
