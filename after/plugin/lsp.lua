bind("n", "gr", vim.lsp.buf.rename)
bind("n", "go", vim.lsp.buf.code_action)
bind("n", "gd", vim.lsp.buf.definition)
bind("n", "gi", vim.lsp.buf.references)
bind("n", "gl", vim.diagnostic.open_float)
bind("n", "gs", vim.lsp.buf.signature_help)
bind("n", "gdl", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>")
bind("n", "gdj", "<cmd>split | lua vim.lsp.buf.definition()<cr>")

vim.api.nvim_create_user_command("LspFmt", function()
    vim.lsp.buf.format({ async = true })
end, {})

vim.lsp.config("*", {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
})

local lsps = { "basedpyright", "clangd", "hls", "nvim_luals", "rust_analyzer" }

for _, lsp in ipairs(lsps) do
    if vim.fn.executable(vim.lsp.config[lsp].cmd[1]) == 1 then
        vim.lsp.enable(lsp)
    end
end
