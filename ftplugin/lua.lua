require("plugins.lspconfig").init("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                unusedLocalExclude = { "_*" },
                globals = { "vim" },
            },
            runtime = { version = "LuaJIT" },
            workspace = {
                library = {
                    vim.env.VIMRUNTIME .. "/lua",
                    "${3rd}/busted/library",
                    "${3rd}/luv/library",
                },
                checkThirdParty = "Disable",
            },
            completion = {
                callSnippet = "Replace",
            },
        },
    },
})
