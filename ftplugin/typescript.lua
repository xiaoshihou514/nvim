require("plugins.guard")

ft("typescript"):fmt({
    cmd = "prettier",
    args = { "--stdin-filepath" },
    fname = true,
    stdin = true,
})
