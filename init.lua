-- enable lua byte code cacheing
vim.loader.enable()

---@diagnostic disable: inject-field
-- disable builtin plugins
vim.g.loaded_fzf = 1
vim.g.loaded_gzip = 1
vim.g.editorconfig = false
vim.g.loaded_matchit = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_tutor_mode_plugin = 1

require("nano")
