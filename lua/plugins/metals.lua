local loaded

return {
    init = function()
        if not loaded then
            vim.cmd.packadd("plenary")
            vim.cmd.packadd("metals")
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

        metals_config.on_attach = lsp_default_config.on_attach

        metals_config.capabilities = lsp_default_config.capabilities

        metals.initialize_or_attach(metals_config)
    end,
}
