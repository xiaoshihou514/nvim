vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

require("plugins.guard")
ft("haskell"):fmt("ormolu"):lint("hlint")
