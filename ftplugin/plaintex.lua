require("plugins.guard")

ft("plaintex"):fmt({
    cmd = "latexindent",
    args = { "-l", "-m", "-g", "/dev/null" },
    stdin = true,
})
