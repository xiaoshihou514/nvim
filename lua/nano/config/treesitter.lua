-- for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
--     config.install_info.url =
--         config.install_info.url:gsub("https://github.com/", "https://ghproxy.com/https://github.com/")
-- end

require("treesitter").setup({
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
    auto_install = false,
    ignore_install = {},
    highlight = {
        enable = true,
        disable = function(_, buf)
            local max_filesize = 1024 * 1024 -- 1MB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end,
        additional_vim_regex_highlighting = false,
    },
})
