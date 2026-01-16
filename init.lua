vim.loader.enable()

vim.g.loaded_fzf = 1
vim.g.loaded_gzip = 1
vim.g.loaded_matchit = 1
vim.g.c_syntax_for_h = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_remote_plugins = 1
vim.g.loaded_python3_provider = 0
vim.g.loaded_tutor_mode_plugin = 1

vim.pack.add({
    "https://github.com/echasnovski/mini.hipatterns",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/nvimdev/guard-collection",
    "https://github.com/nvimdev/guard.nvim",
    "https://github.com/nvimdev/indentmini.nvim",
    "https://github.com/nvimdev/phoenix.nvim",
    "https://github.com/scalameta/nvim-metals",
    "https://github.com/xiaoshihou514/git-conflict.nvim",
    "https://github.com/xiaoshihou514/squirrel.nvim",
    "https://github.com/Julian/lean.nvim",
})

vim.api.nvim_create_autocmd("BufRead", {
    callback = function()
        local plugins = vim.fn.stdpath("data") .. "/site/pack/core/opt/"
        local uv = vim.uv
        ---@diagnostic disable-next-line: param-type-mismatch
        local handle = assert(uv.fs_opendir(plugins, nil, 4096))
        ---@diagnostic disable-next-line: param-type-mismatch
        for _, t in ipairs(uv.fs_readdir(handle, nil)) do
            if t.type == "directory" then
                local name = t.name
                    :gsub("%.nvim$", "")
                    :gsub("%-nvim$", "")
                    :gsub("^nvim%-", "")
                    :gsub("%.", "-")
                local ok, result = pcall(require, "plugins." .. name)
                if not ok and not result:match("module 'plugins%.(.+)' not found:") then
                    error(result, vim.log.levels.ERROR)
                end
            end
        end
    end,
})

vim.cmd.colorscheme("moonlight")
