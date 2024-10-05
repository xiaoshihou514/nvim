require("plugins.guard")

ft("zig"):fmt({
    fn = require("guard.lsp").format,
    ignore_error = true,
})
