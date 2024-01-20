---@diagnostic disable: inject-field
-- load rocks.nvim
local rocks_config = {
    rocks_path = "/home/xiaoshihou/.local/share/nvim/rocks",
    luarocks_binary = "/home/xiaoshihou/.local/share/nvim/rocks/bin/luarocks",
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

-- load time tracking module
local perf = require("nano.perf")

require("nano.loader").lazy_load_modules()
require("nano.loader").lazy_load_lang_modules()

require("nano.builtin.options")
require("nano.builtin.keys")
local dashboard = require("nano.module.dashboard")
vim.cmd.colorscheme("moonlight")
if vim.fn.argc() == 0 then
    vim.cmd.rshada()
    dashboard(perf.cputime())
end
