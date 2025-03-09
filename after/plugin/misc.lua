local api = vim.api

local function create_padwin(direction)
    local padrate = 0.2
    local win = api.nvim_open_win(api.nvim_create_buf(false, true), false, {
        style = "minimal",
        split = direction,
        width = math.floor(vim.o.columns * padrate),
        focusable = false,
    })
    vim.wo[win].winhighlight = "WinBarNC:Hide,WinBar:Hide"
    vim.wo[win].fillchars = "eob: ,fold: ,vert: "
end

api.nvim_create_user_command("Zen", function()
    if #api.nvim_tabpage_list_wins(api.nvim_get_current_tabpage()) ~= 1 then
        vim.cmd.only()
        vim.wo.fillchars = "eob: ,fold: "
        return
    end

    create_padwin("left")
    create_padwin("right")

    vim.wo.fillchars = "eob: ,fold: ,vert: "
end, { nargs = 0 })

bind("n", "<leader>z", "<cmd>Zen<cr>")
