vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    -- Use a sharp border with `FloatBorder` highlights
    border = "single",
})

vim.diagnostic.config({
    float = { border = "single" },
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
})

bind("n", "]d", function()
    vim.diagnostic.jump({ count = 1 })
end)
bind("n", "[d", function()
    vim.diagnostic.jump({ count = -1 })
end)
bind("n", "gr", vim.lsp.buf.rename)
bind("n", "go", vim.lsp.buf.code_action)
bind("n", "gD", vim.lsp.buf.declaration)
bind("n", "gd", vim.lsp.buf.definition)
bind("n", "gi", vim.lsp.buf.implementation)
bind("n", "gy", vim.lsp.buf.type_definition)
bind("n", "gl", vim.diagnostic.open_float)
bind("n", "gs", vim.lsp.buf.signature_help)
bind("n", "K", vim.lsp.buf.hover)
