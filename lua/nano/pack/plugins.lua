local ft = require("nano.loader.filetype")
local plugins = {
    {
        "seandewar/bad-apple.nvim",
        cmd = "BadApple",
    },
    {
        "numToStr/Comment.nvim",
        event = "BufEnter"
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
    },
    {
        "echasnovski/mini.hipatterns",
        event = "BufEnter",
    },
    {
        "nvimdev/epo.nvim",
        event = "LspAttach",
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        ft = ft.src,
    },
    {
        "williamboman/mason.nvim",
        cmd = {
            "Mason",
            "MasonInstall",
            "MasonLog",
            "MasonUninstall",
            "MasonUninstallAll",
            "MasonUpdate",
        },
        build = ":MasonUpdate",
    },
    {
        "nvimdev/guard.nvim",
        ft = ft.format_enabled,
    },
    {
        "lewis6991/satellite.nvim",
        ft = ft.src,
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = {
            {
                "nvim-telescope/telescope.nvim",
                dependencies = {
                    { "nvim-lua/plenary.nvim" },
                    { "nvim-tree/nvim-web-devicons" },
                }
            }
        }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        ft = ft.ts_enabled,
    },
    {
        "rcarriga/nvim-dap-ui",
        ft = ft.dap_enabled,
    },
    {
        "neovim/nvim-lspconfig",
        ft = ft.lsp_enabled,
    },
    {
        "mfussenegger/nvim-dap",
        ft = ft.dap_enabled,
    }
}
return plugins
