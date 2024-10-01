vim.loader.enable()

vim.g.loaded_fzf = 1
vim.g.loaded_gzip = 1
vim.g.loaded_matchit = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_remote_plugins = 1
vim.g.loaded_python3_provider = 0
vim.g.loaded_tutor_mode_plugin = 1

local packpath = vim.fn.stdpath("config") .. "/pack"
vim.opt.packpath:append(packpath)
local plugins = packpath .. "/data/opt/"

vim.api.nvim_create_autocmd("UIEnter", {
    callback = function()
        local uv = vim.uv
        local handle = assert(uv.fs_opendir(plugins, nil, 4096))
        for _, t in ipairs(uv.fs_readdir(handle, nil)) do
            if t.type == "directory" then
                vim.cmd.packadd(t.name)
                pcall(require, "plugins." .. t.name)
            end
        end
    end,
})

vim.cmd.colorscheme("moonlight")

-- show dashboard after init
vim.api.nvim_create_autocmd("UIEnter", {
    callback = function()
        if vim.fn.argc() == 0 then
            vim.cmd.rshada()
            require("personal.dashboard")
        end
    end,
})
