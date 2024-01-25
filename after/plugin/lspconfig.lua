require("lspconfig.ui.windows").default_options.border = "single"
require("lspconfig.ui.windows").default_options.winhighlight = "FloatBorder:Normal"

local lspconfig = require("lspconfig")

lspconfig.kotlin_language_server.setup({
    capabilities = lsp_default_cap
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

