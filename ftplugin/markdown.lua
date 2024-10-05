vim.opt_local.wrap = true
vim.opt_local.spell = true

require("plugins.guard")

ft("markdown"):fmt({
    cmd = "prettier",
    args = { "--stdin-filepath" },
    fname = true,
    stdin = true,
})
