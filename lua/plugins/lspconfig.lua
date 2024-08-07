return {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
        require("lspconfig.ui.windows").default_options.border = "single"
        require("lspconfig.ui.windows").default_options.winhighlight =
            "FloatBorder:Normal"

        local lspconfig = require("lspconfig")

        -- enable semantic highlighting
        local default = {
            on_attach = function(client, buf)
                if client.server_capabilities.semanticTokensProvider then
                    vim.lsp.semantic_tokens.start(buf, client.id)
                end
            end,
        }

        -- lua
        lspconfig.lua_ls.setup({
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

        -- dart
        -- lspconfig.dartls.setup(default)

        -- kotlin
        -- lspconfig.kotlin_language_server.setup(default)

        -- c, cpp
        lspconfig.clangd.setup(default)

        -- nix
        -- lspconfig.nixd.setup(default)

        -- python
        -- lspconfig.basedpyright.setup(default)
        -- lspconfig.ruff.setup(default)

        -- zig
        lspconfig.zls.setup(default)

        -- rust
        -- lspconfig.rust_analyzer.setup(default)
    end,
}
