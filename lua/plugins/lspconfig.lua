local lspconfig = nil
local default = nil

return {
    init = function(server, opts)
        if not lspconfig then
            require("lspconfig.ui.windows").default_options.border = "single"
            require("lspconfig.ui.windows").default_options.winhighlight =
                "FloatBorder:Normal"
            lspconfig = require("lspconfig")
            -- enable semantic highlighting
            default = {
                on_attach = function(client, buf)
                    if client.server_capabilities.semanticTokensProvider then
                        vim.lsp.semantic_tokens.start(buf, client.id)
                    end
                end,
            }
        end
        lspconfig[server].setup(opts or default)
        vim.cmd("LspStart")
    end,
}
