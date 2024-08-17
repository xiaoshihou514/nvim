local metals = nil
local metals_config = nil

return {
    init = function()
        metals = metals or require("metals")

        if not metals_config then
            metals_config = metals.bare_config()
            metals_config.on_attach = function(client, buf)
                if client.server_capabilities.semanticTokensProvider then
                    vim.lsp.semantic_tokens.start(buf, client.id)
                end
            end
        end

        metals.initialize_or_attach(metals_config)
    end,
}
