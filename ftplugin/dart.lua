vim.opt_local.shiftwidth = 2
vim.opt_local.commentstring = "// %s"

local ft = require("guard.filetype")

ft("dart"):fmt({
    cmd = "dart",
    args = { "format" },
    stdin = true,
})
