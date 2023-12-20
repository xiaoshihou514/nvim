require("telescope").setup({
    defaults = {
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
                results_width = 0.8,
            },
            vertical = {
                mirror = false,
            },
            width = 0.95,
            height = 0.95,
            preview_cutoff = 120,
        },
        mappings = {
            i = {
                ["<C-x>"] = require("telescope.actions").select_vertical,
                ["<C-o>"] = require("telescope.actions").select_horizontal,
            },
            n = {
                ["<C-x>"] = require("telescope.actions").select_vertical,
                ["<C-o>"] = require("telescope.actions").select_horizontal,
            },
        },
    },
})

bind("n", "<leader>r", "<cmd>Telescope oldfiles<cr>", { silent = true })
bind("n", "<leader>g", "<cmd>Telescope live_grep<cr>", { silent = true })
bind("n", "<leader>f", "<cmd>Telescope find_files<cr>", { silent = true })
bind("n", "<leader>b", "<cmd>Telescope buffers<cr>", { silent = true })
bind("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { silent = true })
bind("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { silent = true })
bind("n", "<leader>si", "<cmd>Telescope highlights<cr>", { silent = true })
bind("n", "<leader>sr", "<cmd>Telescope lsp_references<cr>", { silent = true })
bind("n", "<leader>sc", "<cmd>lua require('telescope.builtin').colorscheme({enable_preview=true})<cr>",
    { silent = true })

require("nano.module.elegant")
