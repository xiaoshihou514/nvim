local loaded

return {
    init = function()
        if not loaded then
            loaded = true
        end

        local metals = require("metals")
        local metals_config = metals.bare_config()

        metals_config.tvp = {
            icons = { enabled = true },
        }

        metals_config.settings = {
            showImplicitArguments = true,
            showImplicitConversionsAndClasses = true,
            showInferredType = true,
        }

        metals_config.init_options = {
            statusBarProvider = "off",
            icons = "unicode",
        }

        metals_config.capabilities = vim.lsp.protocol.make_client_capabilities()

        metals.initialize_or_attach(metals_config)
    end,
}
