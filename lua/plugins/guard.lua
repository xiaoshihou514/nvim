local loaded
if loaded then
    return
end
loaded = true

vim.cmd.packadd("guard")
vim.cmd.packadd("guard-collection")

vim.g.guard_config = {
    diagnostic_refresh = true,
}

_G.ft = require("guard.filetype")
local lint = require("guard.lint")

bind("n", "gq", "<cmd>Guard fmt<cr>")

ft("c,cpp"):fmt("clang-format")

ft(table.concat({
    "css",
    "html",
    "javaascript",
    "javascriptreact",
    "json",
    "markdown",
    "typescript",
    "typescriptreact",
    "yaml",
}, ",")):fmt("prettier")

ft("dart"):fmt("dart")
ft("fish"):fmt("fish_indent")
ft("haskell"):fmt("ormolu"):lint("hlint")

ft("kotlin"):fmt("ktlint"):lint("ktlint"):append({
    cmd = "detekt-cli",
    args = { "-i" },
    fname = true,
    parse = lint.from_regex({
        source = "detekt",
        regex = ":(%d+):(%d+):%s(.+)%s%[(.+)%]",
        groups = { "lnum", "col", "message", "code" },
    }),
})

ft("lua"):fmt("stylua")

ft("tex,plaintex"):fmt({
    cmd = "latexindent",
    args = { "-l", "-m", "-g", "/dev/null" },
    stdin = true,
})

ft("python"):fmt("ruff")
ft("rust"):fmt("rustfmt")
ft("scala"):fmt("lsp")

ft("zig"):fmt({
    fn = require("guard.lsp").format,
    ignore_error = true,
})

ft("typst"):fmt("typstyle")
ft("clojure"):fmt("cljfmt")
