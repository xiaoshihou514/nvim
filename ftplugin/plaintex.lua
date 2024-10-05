local ft = require("guard.filetype")

ft("plaintex"):fmt({
    cmd = "latexindent",
    args = { "-l", "-m", "-g", "/dev/null" },
    stdin = true,
})
