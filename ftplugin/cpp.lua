vim.opt_local.cinkeys:remove(":")

require("plugins.guard")

ft("cpp"):fmt("clang-format")
