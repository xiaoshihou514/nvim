vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "scala",
        "zig",
        "markdown",
        "lua",
        "vim",
        "help",
        "fish",
        "c",
        "cpp",
        "cmake",
        "typescript",
        "typescriptreact",
    },
    callback = function()
        vim.treesitter.start()
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
