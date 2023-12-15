vim.g.mapleader = " "
vim.g.maplocalleader = " "

bind({ "n", "x", "t" }, "<leader>q", function()
    if not pcall(vim.api.nvim_command, "silent close") then
        vim.api.nvim_command("quit")
    end
end)
bind("n", "<leader>w", "<cmd>silent w<cr>")
bind("n", "<leader>h", "<cmd>noh<cr>")
bind("n", "<leader>;", "<cmd>lua require('xsh.dashboard').new()<cr>")

bind("n", "<leader>ba", "<cmd>$tabnew<cr>")
bind("n", "<leader>bl", "<cmd>source %<cr>")

bind("n", "<leader>b", "<cmd>Flip<cr>")
bind("n", "<leader>tt", "<cmd>Flip!<cr>")
bind("n", "<leader>tf", "<cmd>FloatTerm<cr>")
bind("n", "<leader>TF", "<cmd>FloatTerm!<cr>")
