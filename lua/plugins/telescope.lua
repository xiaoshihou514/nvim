bind(
    "n",
    "<leader>e",
    "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>",
    { silent = true }
)
bind("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { silent = true })

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        opts = function()
            local actions = require("telescope.actions")

            return {
                defaults = {
                    preview = false,
                    borderchars = {
                        "─",
                        "│",
                        "─",
                        "│",
                        "┌",
                        "┐",
                        "┘",
                        "└",
                    },
                    mappings = {
                        i = {
                            ["<C-x>"] = actions.select_vertical,
                            ["<C-o>"] = actions.select_horizontal,
                            ["<C-t>"] = actions.select_tab,
                            ["<C-e>"] = actions.close,
                        },
                        n = {
                            ["<C-x>"] = actions.select_vertical,
                            ["<C-o>"] = actions.select_horizontal,
                            ["<C-t>"] = actions.select_tab,
                            ["<C-e>"] = actions.close,
                        },
                    },
                },
                pickers = {
                    live_grep = { theme = "ivy" },
                    oldfiles = { theme = "ivy" },
                    buffers = { theme = "ivy" },
                    help_tags = { theme = "ivy" },
                    keymaps = { theme = "ivy" },
                    lsp_references = { theme = "ivy" },
                    find_files = { theme = "ivy", preview = true },
                    highlights = { theme = "ivy", preview = true },
                    colorscheme = { enable_preview = true, theme = "ivy" },
                },
                extensions = {
                    file_browser = {
                        initial_mode = "normal",
                        theme = "ivy",
                        -- disables netrw and use telescope-file-browser in its place
                        hijack_netrw = true,
                    },
                },
            }
        end,
        event = "VeryLazy",
    },
    {

        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("telescope").load_extension("file_browser")
        end,
        event = "VeryLazy",
    },
}
