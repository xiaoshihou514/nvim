local patterns = {
    ["*"] = { ".git", ".editorconfig" },
    scala = { "build.sbt", "project.scala" },
    zig = { "build.zig" },
    rust = { "Cargo.toml" },
    lua = { "stylua.toml", ".stylua.toml" },
    haskell = { "*.cabal" },
    cpp = { "CMakeList.txt", "Makefile" },
    c = { "Makefile" },
    dart = { "pubspec.yaml" },
    javascript = { "package.json" },
    python = { "pyproject.toml", "requirements.txt" },
}

_G.root_patterns = setmetatable({}, {
    __index = function(_, k_)
        local v = vim.iter(vim.islist(k_) and k_ or { k_ })
            :map(function(k)
                return rawget(patterns, k)
            end)
            :flatten()
            :totable()
        return vim.list_extend(v, rawget(patterns, "*"))
    end,
})

_G.bind = vim.keymap.set

---@diagnostic disable: inject-field
vim.g.mapleader = " "
vim.g.maplocalleader = " "
