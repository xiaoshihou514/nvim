require("plugins.guard")

ft("python"):fmt({
    cmd = "ruff",
    args = { "format", "-" },
    stdin = true,
})
