local ft = require("guard.filetype")

ft("fish"):fmt({
    cmd = "fish_indent",
    stdin = true,
})
