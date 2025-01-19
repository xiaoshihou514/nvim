_G.root_patterns = {
    ".git",
    ".editorconfig",
    "build.sbt",
    "project.scala",
    "build.zig",
    "Cargo.toml",
    "stylua.toml",
    "*.cabal",
    "CMakeList.txt",
    "Makefile",
    "pubspec.yaml",
    "package.json",
    "go.mod",
}

_G.lsp_default_config = {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
}

_G.bind = function(mode, key, binding, opts)
    vim.keymap.set(mode, key, binding, opts or {})
end

---@diagnostic disable: inject-field
vim.g.mapleader = " "
vim.g.maplocalleader = " "
