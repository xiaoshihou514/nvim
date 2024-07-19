-- Quicker window manipulation
bind("n", "<C-h>", "<C-w>h")
bind("n", "<C-l>", "<C-w>l")
bind("n", "<C-j>", "<C-w>j")
bind("n", "<C-k>", "<C-w>k")
bind("n", "<C-Right>", "<C-w><")
bind("n", "<C-Left>", "<C-w>>")
-- Move visually
bind("n", "j", "gj")
bind("n", "k", "gk")
-- Move text up and down
bind({ "n", "v" }, "<A-j>", ":m .+1<CR>==")
bind({ "n", "v" }, "<A-k>", ":m .-2<CR>==")
-- Faster indent
bind("n", ">", ">>")
bind("n", "<", "<<")
-- Tired of reaching for ^ and $
bind({ "n", "o", "x" }, "H", "^")
bind({ "n", "o", "x" }, "L", "$")
-- Center search
bind("n", "n", "nzz")
bind("n", "N", "Nzz")
-- evil bindings
bind({ "i", "c" }, "<C-n>", "<Down>")
bind({ "i", "c" }, "<C-p>", "<Up>")
bind({ "i", "c" }, "<C-f>", "<Right>")
bind({ "i", "c" }, "<C-b>", "<Left>")
bind({ "i", "c" }, "<C-a>", "<Home>")
bind("i", "<A-f>", "<Esc>wa")
bind("i", "<A-b>", "<Esc>bi")
bind("i", "<C-e>", "<End>")
-- better indent
bind("v", "<", "<gv")
bind("v", ">", ">gv")
-- Move text up and down
bind("x", "<A-j>", ":move '>+1<CR>gv-gv")
bind("x", "<A-k>", ":move '<-2<CR>gv-gv")
-- better escape imo
bind("i", "qi", "<ESC>")
bind("v", "qv", "<ESC>")
bind("t", "qt", "<C-\\><C-n>")
-- paste in insert
bind("i", "<C-v>", '<C-r>"')
-- C-a is taken by kitty
bind("n", "=", "<C-a>")
bind("n", "-", "<C-x>")
-- abbreviates
vim.cmd.cnoreabbrev("h vert help")
vim.cmd.cnoreabbrev("E edit")

-- misc
bind("v", "p", '"_dP') -- paste without replacing clipboard contents
bind("n", "<A-v>", "<C-v>") -- rebind Ctrl v since I use it as paste
bind("n", "??", ":vert help <C-r><C-w><cr>") -- Open help for current word
bind("n", "!!", ":<Up><cr>") -- Run last command
bind("c", "<C-e>", "<C-f>") -- edit commands is now <C-e>

bind({ "n", "x", "t" }, "<leader>q", function()
    vim.api.nvim_command("quit")
end)
bind("n", "<leader>w", "<cmd>silent w<cr>")
bind("n", "<leader>h", "<cmd>noh<cr>")
bind("n", "<leader>;", "<cmd>source ~/.config/nvim/lua/personal/dashboard.lua<cr>")

bind("n", "<leader>a", "<cmd>$tabnew<cr>")
bind("n", "<leader>l", "<cmd>source %<cr>")

bind("n", "<leader>t", "<cmd>FloatTerm<cr>")
bind("n", "<leader>tt", "<cmd>FloatTerm!<cr>")
