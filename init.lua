_G.bind = function(mode, key, binding, opts)
    vim.keymap.set(mode, key, binding, opts or {})
end
---@diagnostic disable: inject-field
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    -- local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local lazyrepo = "https://mirror.ghproxy.com/github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = { { import = "plugins" } },
    git = {
        -- url_format = "https://github.com/%s.git",
        url_format = "https://mirror.ghproxy.com/github.com/%s.git",
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
    ui = { border = "single" },
})

vim.api.nvim_create_autocmd("UIEnter", {
    callback = function()
        if vim.fn.argc() == 0 then
            vim.cmd.rshada()
            require("personal.dashboard")
        end
    end,
})

vim.cmd("colorscheme moonlight")
