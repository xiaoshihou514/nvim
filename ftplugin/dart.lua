vim.opt_local.shiftwidth = 2
vim.opt_local.commentstring = "// %s"

require("plugins.guard")

ft("dart"):fmt({
    cmd = "dart",
    args = { "format" },
    stdin = true,
})
