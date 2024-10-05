require("plugins.guard")

ft("html"):fmt({
    cmd = "prettier",
    args = { "--stdin-filepath" },
    fname = true,
    stdin = true,
})
