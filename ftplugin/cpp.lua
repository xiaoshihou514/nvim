vim.opt_local.cinkeys:remove(":")

local ft = require("guard.filetype")

ft("cpp"):fmt("clang-format")
