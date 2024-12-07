local lspconfig = require("lspconfig")
local function use(server)
    lspconfig[server].setup(lsp_default_config)
end

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

lspconfig.eslint.setup({
    settings = {
        workingDirectories = { mode = "auto" },
        experimental = {
            useFlatConfig = true,
        },
    },
})

use("hls")
use("zls")
use("clangd")
use("jdtls")
use("basedpyright")
use("kotlin_language_server")
