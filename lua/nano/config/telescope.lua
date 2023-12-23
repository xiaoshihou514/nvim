local actions = require("telescope.actions")

require("telescope").setup({
    defaults = {
        preview = false,
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
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
    }
})

bind("n", "<leader>r", "<cmd>Telescope oldfiles<cr>", { silent = true })
bind("n", "<leader>g", "<cmd>Telescope live_grep<cr>", { silent = true })
bind("n", "<leader>f", "<cmd>Telescope find_files<cr>", { silent = true })
bind("n", "<leader>b", "<cmd>Telescope buffers<cr>", { silent = true })
bind("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { silent = true })
bind("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { silent = true })
bind("n", "<leader>si", "<cmd>Telescope highlights<cr>", { silent = true })
bind("n", "<leader>sr", "<cmd>Telescope lsp_references<cr>", { silent = true })
bind("n", "<leader>sc", "<cmd>Telescope colorscheme<cr>", { silent = true })
