require("git-conflict").setup({
    default_mappings = false,
    disable_diagnostics = true,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "GitConflictDetected",
    callback = function()
        bind("n", "go", "<Plug>(git-conflict-ours)", { force = true })
        bind("n", "gt", "<Plug>(git-conflict-theirs)", { force = true })
        bind("n", "gb", "<Plug>(git-conflict-both)", { force = true })
        bind("n", "gn", "<Plug>(git-conflict-none)", { force = true })
        bind("n", "[x", "<Plug>(git-conflict-prev-conflict)", { force = true })
        bind("n", "]x", "<Plug>(git-conflict-next-conflict)", { force = true })
    end,
})
