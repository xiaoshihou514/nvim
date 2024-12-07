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

vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")
local packpath = vim.fn.stdpath("config") .. "/pack"
vim.opt.packpath:append(packpath)
local plugins = packpath .. "/data/opt/"

vim.api.nvim_create_autocmd("BufRead", {
    callback = function()
        local uv = vim.uv
        ---@diagnostic disable: undefined-field
        local handle = assert(uv.fs_opendir(plugins, nil, 4096))
        for _, t in ipairs(uv.fs_readdir(handle, nil)) do
            if t.type == "directory" then
                vim.cmd.packadd(t.name)
                local ok, result = pcall(require, "plugins." .. t.name)
                if not ok and not result:match("module 'plugins%.(.+)' not found:") then
                    error(result, vim.log.levels.ERROR)
                end
            end
        end
    end,
})

vim.cmd.colorscheme("moonlight")
-- vim.cmd.colorscheme("twilight")

-- show dashboard after init
vim.api.nvim_create_autocmd("UIEnter", {
    callback = function()
        if vim.fn.argc() == 0 then
            vim.cmd.rshada()
            require("personal.dashboard")
        end
    end,
})
