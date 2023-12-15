_G.dbg = function(...)
    vim.print(...)
end
_G.ndbg = function(...)
    vim.notify(vim.inspect(...), 4)
end
_G.api = vim.api
vim.api.nvim_create_user_command("I", function(opts)
    vim.print(vim.fn.luaeval(opts.args))
end, { nargs = 1, complete = "lua" })
