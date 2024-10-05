local ft = require("guard.filetype")

ft("python"):fmt({
    cmd = "ruff",
    args = { "format", "-" },
    stdin = true,
})
