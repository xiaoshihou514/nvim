local telescope = require("telescope")

telescope.setup({
    extensions = {
        file_browser = {
            initial_mode = "normal",
            theme = "ivy",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
        },
    },
})

telescope.load_extension("file_browser")
bind("n", "<leader>e", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", { silent = true })
