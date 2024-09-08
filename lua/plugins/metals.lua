local metals = nil
local metals_config = nil

return {
    init = function()
        metals = metals or require("metals")

        if not metals_config then
            metals_config = metals.bare_config()
            metals_config.tvp = {
                icons = {
                    enabled = true,
                },
            }

            metals_config.settings = {
                enableSemanticHighlighting = false,
                showImplicitArguments = true,
                showImplicitConversionsAndClasses = true,
                showInferredType = true,
            }
        end

        metals.initialize_or_attach(metals_config)
    end,
}
