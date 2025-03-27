_G.root_patterns = setmetatable({
    ["*"] = { ".git", ".editorconfig" },
    scala = { "build.sbt", "project.scala" },
    zig = { "build.zig" },
    rust = { "Cargo.toml" },
    lua = { "stylua.toml" },
    haskell = { "*.cabal" },
    cpp = { "CMakeList.txt", "Makefile" },
    c = { "Makefile" },
    dart = { "pubspec.yaml" },
    javascript = { "package.json" },
    python = { "pyproject.toml", "requirements.txt" },
}, {
    __index = function(t, k_)
        local ks = vim.islist(k_) and k_ or { k_ }
        local v = vim.iter(ks)
            :map(function(k)
                return rawget(t, k)
            end)
            :flatten()
            :totable()
        return vim.list_extend(v, rawget(t, "*"))
    end,
})

_G.bind = vim.keymap.set

---@diagnostic disable: inject-field
vim.g.mapleader = " "
vim.g.maplocalleader = " "
