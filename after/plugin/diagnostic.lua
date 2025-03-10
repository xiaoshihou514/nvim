vim.diagnostic.config({
    severity_sort = true,
    update_in_insert = false,
    virtual_lines = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
})

bind("n", "gr", vim.lsp.buf.rename)
bind("n", "go", vim.lsp.buf.code_action)
bind("n", "gD", vim.lsp.buf.declaration)
bind("n", "gd", vim.lsp.buf.definition)
bind("n", "gi", vim.lsp.buf.implementation)
bind("n", "gy", vim.lsp.buf.type_definition)
bind("n", "gl", vim.diagnostic.open_float)
bind("n", "gs", vim.lsp.buf.signature_help)
bind("n", "gdl", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>")
bind("n", "gdj", "<cmd>split | lua vim.lsp.buf.definition()<cr>")

vim.api.nvim_create_user_command("LspFmt", function()
    vim.lsp.buf.format({ async = true })
end, {})
