local ft = require("guard.filetype")

ft("zig"):fmt({
    fn = require("guard.lsp").format,
    ignore_error = true,
})
