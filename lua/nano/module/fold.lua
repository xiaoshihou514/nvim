-- fold stuff
vim.wo.foldtext = ""
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.fcs:append("eob: ,fold: ")
local api = vim.api

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

bind("n", "zp", peek, { noremap = true, silent = true, desc = "Peek this fold" })
