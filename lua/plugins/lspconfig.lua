local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup({
    on_init = function(client)
        client.config.settings.Lua =
            vim.tbl_deep_extend("force", client.config.settings.Lua, {
                runtime = { version = "LuaJIT" },
                workspace = {
                    checkThirdParty = false,
                    library = { vim.env.VIMRUNTIME },
                },
            })
    end,
    on_attach = lsp_default_config.on_attach,
    settings = {
        Lua = {},
    },
})
lspconfig.zls.setup(lsp_default_config)
lspconfig.clangd.setup(lsp_default_config)
