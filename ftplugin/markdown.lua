vim.opt_local.wrap = true
vim.opt_local.spell = true

require("plugins.guard")

ft("markdown"):fmt("prettier")
