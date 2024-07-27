local api = vim.api

api.nvim_create_user_command("Dired", function(opts)
    local cwd = opts.fargs[1] or vim.fn.getcwd()
    local height, width = vim.o.lines, vim.o.columns
    local pad_top = math.ceil(height * 0.1)
    api.nvim_open_win(api.nvim_create_buf(false, true), true, {
        relative = "editor",
        row = pad_top,
        col = math.floor(width * 0.2),
        height = height - pad_top * 2,
        width = math.ceil(width * 0.6),
        border = "single",
    })
    api.nvim_command("silent! lcd " .. cwd)
    vim.bo.ft = "dired"
end, { nargs = "?" })

bind("n", "<leader>e", "<cmd>Dired<cr>")
