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
        "typescript",
        "typescriptreact",
    },
    callback = function()
        vim.treesitter.start()
    end,
})
