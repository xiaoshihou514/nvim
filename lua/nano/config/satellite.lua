require("satellite").setup({
    current_only = true,
    excluded_filetypes = {
        "help",
        "mason",
        "nofile",
        "text",
        "query",
        "lspinfo",
        "floatterm",
        "elegant",
        "",
    },
    handlers = {
        gitsigns = { enable = false },
        marks = { enable = false },
    },
})
