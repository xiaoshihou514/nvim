require("lspconfig.ui.windows").default_options.border = "single"
require("lspconfig.ui.windows").default_options.winhighlight = "FloatBorder:Normal"

local lspconfig = require("lspconfig")

local on_attach = function(client, buf)
    vim.lsp.semantic_tokens.start(buf, client.id)
end

lspconfig.kotlin_language_server.setup({
    capabilities = lsp_default_cap,
    on_attach = on_attach,
})

lspconfig.lua_ls.setup({
    capabilities = lsp_default_cap,
    settings = {
        Lua = {
            diagnostics = {
                enable = true,
                globals = { "vim" },
            },
            runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
            },
            workspace = {
                library = { vim.env.VIMRUNTIME, },
                checkThirdParty = false,
            },
            completion = { callSnippet = "Replace" },
        },
    },
})

lspconfig.dartls.setup({
    capabilities = lsp_default_cap,
    on_attach = on_attach,
})

lspconfig.clangd.setup({
    capabilities = lsp_default_cap,
    on_attach = on_attach,
})
