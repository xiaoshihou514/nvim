vim.opt_local.tabstop = 2

require("plugins.guard")

ft("json"):fmt("prettier")
