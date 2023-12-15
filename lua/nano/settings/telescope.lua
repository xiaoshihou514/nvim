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
    mappings = {},
    extensions = {
        file_browser = {
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
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
        },
    },
})
require("telescope").load_extension("file_browser")
