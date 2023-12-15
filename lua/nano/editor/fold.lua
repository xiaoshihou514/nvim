-- foldtext customization
vim.o.foldtext = "v:lua.foldtext()"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.fcs:append("eob: ,fold: ")
local api = vim.api

-- https://www.reddit.com/r/neovim/comments/16sqyjz/finally_we_can_have_highlighted_folds/
-- I just added the line count and find first non-empty line
_G.foldtext = function()
    local start, foldend = vim.v.foldstart, vim.v.foldend
    local linenr = start
    local line = api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
    while line == "" do
        linenr = linenr + 1
        line = api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
    end
    local decorator = "  " .. (foldend - start + 1) .. " lines ↙"

    local parser = vim.treesitter.get_parser(0, vim.treesitter.language.get_lang(vim.bo.ft))
    local query = vim.treesitter.query.get(parser:lang(), "highlights")
    if not query then
        return line .. decorator
    end
    local tree = parser:parse({ start - 1, start })[1]
    local result = {}
    local line_pos = 0
    local prev_range = nil
    for id, node, _ in query:iter_captures(tree:root(), 0, start - 1, start) do
        local name = query.captures[id]
        local start_row, start_col, end_row, end_col = node:range()
        if start_row == start - 1 and end_row == start - 1 then
            local range = { start_col, end_col }
            if start_col > line_pos then
                table.insert(result, { line:sub(line_pos + 1, start_col), "Folded" })
            end
            line_pos = end_col
            local text = vim.treesitter.get_node_text(node, 0)
            if prev_range ~= nil and range[1] == prev_range[1] and range[2] == prev_range[2] then
                result[#result] = { text, "@" .. name }
            else
                table.insert(result, { text, "@" .. name })
            end
            prev_range = range
        end
    end
    table.insert(result, { decorator, "Function" })
    return result
end

local winid = -1
-- preview fold contents in a float window
local function peek()
    if winid and winid ~= -1 then
        api.nvim_win_close(winid, true)
        winid = -1
        return
    end
    -- Get contents of fold
    local fold_start = vim.fn.foldclosed(".")
    if fold_start == -1 then
        return
    end -- Not a valid fold
    local fold_end = vim.fn.foldclosedend(".")
    local folded_lines = api.nvim_buf_get_lines(0, fold_start - 1, fold_end, true)

    -- Trim tabs and try to truncate common indents
    local max_len = -1
    local spaces = folded_lines[1]:match("^%s+"):len()
    for i, line in pairs(folded_lines) do
        folded_lines[i] = line:gsub("\t", string.rep(" ", vim.o.tabstop))
        if line:len() > max_len then
            max_len = line:len()
        end
        local count = line:match("^%s+"):len()
        if count < spaces then
            spaces = count
        end
    end
    if spaces ~= 0 then
        for i, line in pairs(folded_lines) do
            folded_lines[i] = line:sub(spaces + 1, -1)
        end
    end
    -- Init container buf
    local previewbuf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_lines(previewbuf, 0, 1, false, folded_lines)
    vim.bo[previewbuf].filetype = vim.bo.filetype
    vim.bo[previewbuf].modifiable = false
    -- See if we put the window above or below
    local cursor_pos = vim.fn.winline()
    local v_space = math.max(vim.o.lines - cursor_pos, cursor_pos)
    local anchor = (v_space == cursor_pos) and "SW" or "NW"
    winid = api.nvim_open_win(previewbuf, false, {
        anchor = anchor,
        relative = "win",
        row = cursor_pos,
        col = vim.fn.getwininfo(api.nvim_get_current_win())[1].textoff,
        width = math.min(vim.o.columns, max_len),
        height = math.min(v_space, #folded_lines),
        style = "minimal",
        border = "single",
        focusable = false,
        noautocmd = true,
    })
    -- If the cursor moves we close the window
    api.nvim_create_autocmd("CursorMoved", {
        once = true,
        callback = function()
            if winid ~= -1 then
                api.nvim_win_close(winid, true)
                winid = -1
            end
        end,
    })
end

vim.keymap.set("n", "zp", peek, { noremap = true, silent = true, desc = "Peek this fold" })
