vim.opt_local.tabstop = 2

require("plugins.guard")

ft("json"):fmt({
    cmd = "prettier",
    args = { "--stdin-filepath" },
    fname = true,
    stdin = true,
})
