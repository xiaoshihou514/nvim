local api = vim.api

local function create_padwin(direction)
    local padrate = 0.2
    local win = api.nvim_open_win(api.nvim_create_buf(false, true), false, {
        split = direction,
        width = math.floor(vim.o.columns * padrate),
        focusable = false,
    })
    vim.wo[win].cursorline = false
    vim.wo[win].winhighlight = "WinBarNC:Hide,WinBar:Hide"
    vim.wo[win].winbar = ""
    vim.wo[win].fillchars = vim.wo[win].fillchars .. ",vert: "
    return win
end

local bg = api.nvim_get_hl(0, { name = "Normal" }).bg
api.nvim_set_hl(0, "Hide", { fg = bg, bg = bg })

api.nvim_create_user_command("Center", function()
    if #api.nvim_tabpage_list_wins(api.nvim_get_current_tabpage()) ~= 1 then
        vim.cmd.only()
        return
    end

    local orig = api.nvim_get_current_win()
    local left = create_padwin("left")
    local right = create_padwin("right")

    api.nvim_set_current_win(orig)
    vim.wo.fillchars = vim.wo.fillchars .. ",vert: "

    api.nvim_create_autocmd("BufLeave", {
        once = true,
        callback = function()
            api.nvim_win_close(left, true)
            api.nvim_win_close(right, true)
        end,
    })
end, { nargs = 0 })
