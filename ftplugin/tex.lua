local ft = require("guard.filetype")

ft("tex"):fmt({
    cmd = "latexindent",
    args = { "-l", "-m", "-g", "/dev/null" },
    stdin = true,
})
