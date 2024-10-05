require("plugins.guard")

ft("yaml"):fmt({
    cmd = "prettier",
    args = { "--stdin-filepath" },
    fname = true,
    stdin = true,
})
