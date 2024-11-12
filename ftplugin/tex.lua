require("plugins.guard")

ft("tex"):fmt({
    cmd = "latexindent",
    args = { "-l", "-m", "-g", "/dev/null" },
    stdin = true,
})
