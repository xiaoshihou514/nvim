require("lean").setup()

if vim.fn.executable("lake") == 1 then
    vim.lsp.enable("leanls")
end
