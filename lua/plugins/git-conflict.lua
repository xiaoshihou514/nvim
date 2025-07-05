require("git-conflict").setup({
    default_mappings = false,
    disable_diagnostics = true,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "GitConflictDetected",
    callback = function()
        bind("n", "gu", "<Plug>(git-conflict-ours)")
        bind("n", "gt", "<Plug>(git-conflict-theirs)")
        bind("n", "gb", "<Plug>(git-conflict-both)")
        bind("n", "gn", "<Plug>(git-conflict-none)")
        bind("n", "[x", "<Plug>(git-conflict-prev-conflict)")
        bind("n", "]x", "<Plug>(git-conflict-next-conflict)")
    end,
})
