vim.opt_local.cinkeys:remove(">")
vim.opt_local.indentexpr = nil
vim.defer_fn(function()
    require("plugins.metals").init()
end, 50)
