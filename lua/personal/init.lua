-- load time tracking module
local perf = require("personal.perf")

---@diagnostic disable: inject-field, param-type-mismatch
-- load rocks.nvim
local data_path = vim.fn.stdpath("data")
local rocks_config = {
    rocks_path = vim.fs.joinpath(data_path, "rocks"),
    luarocks_binary = vim.fs.joinpath(data_path, "rocks", "bin", "luarocks"),
}
vim.g.rocks_nvim = rocks_config
local luarocks_path = {
    vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
    vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
}
package.path = package.path .. ";" .. table.concat(luarocks_path, ";")
local luarocks_cpath = {
    vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
    vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
}
package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")
vim.opt.runtimepath:append(vim.fs.joinpath(rocks_config.rocks_path, "lib", "luarocks", "rocks-5.1", "*", "*"))

-- personal modules
require("personal.builtin.options")
require("personal.builtin.keys")
vim.api.nvim_create_autocmd("UIEnter", {
    callback = function()
        local dashboard = require("personal.module.dashboard")
        vim.cmd.colorscheme("moonlight")
        if vim.fn.argc() == 0 then
            vim.cmd.rshada()
            dashboard(perf.cputime())
        end
        require("personal.builtin.diagnostic")
        require("personal.builtin.autocmd")

        require("personal.module.ui")
        require("personal.module.fold")
        require("personal.module.indentline")
        require("personal.module.smoothscroll")
        require("personal.module.statusline")
        require("personal.module.term")
        require("personal.module.comment")
        require("personal.module.pairs")
    end
})
