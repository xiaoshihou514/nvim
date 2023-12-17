_G.api = vim.api
vim.api.nvim_create_user_command("I", function(opts)
    vim.print(vim.fn.luaeval(opts.args))
end, { nargs = 1, complete = "lua" })
