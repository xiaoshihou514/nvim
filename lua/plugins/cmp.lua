local cmp_kinds = {
    Text = "  ",
    Method = "  ",
    Function = "  ",
    Constructor = "  ",
    Field = "  ",
    Variable = "  ",
    Class = "  ",
    Interface = "  ",
    Module = "  ",
    Property = "  ",
    Unit = "  ",
    Value = "  ",
    Enum = "  ",
    Keyword = "  ",
    Snippet = "  ",
    Color = "  ",
    File = "  ",
    Reference = "  ",
    Folder = "  ",
    EnumMember = "  ",
    Constant = "  ",
    Struct = "  ",
    Event = "  ",
    Operator = "  ",
    TypeParameter = "  ",
}

return {
    "nvimdev/epo.nvim",
    config = function()
        require("epo").setup({
            fuzzy = true,
            signature_border = "single",
            kind_format = function(k)
                return cmp_kinds[k]
            end,
        })

        _G.lsp_default_cap =
            vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), require("epo").register_cap())

        vim.keymap.set("i", "<TAB>", function()
            if vim.fn.pumvisible() == 1 then
                return "<C-n>"
            elseif vim.snippet.active({ direction = 1 }) then
                return "<cmd>lua vim.snippet.jump(1)<cr>"
            else
                return "<TAB>"
            end
        end, { expr = true })

        vim.keymap.set("i", "<S-TAB>", function()
            if vim.fn.pumvisible() == 1 then
                return "<C-p>"
            elseif vim.snippet.active({ direction = -1 }) then
                return "<cmd>lua vim.snippet.jump(-1)<CR>"
            else
                return "<S-TAB>"
            end
        end, { expr = true })

        vim.keymap.set("i", "<C-e>", function()
            if vim.fn.pumvisible() == 1 then
                require("epo").disable_trigger()
            end
            return "<C-e>"
        end, { expr = true })
    end,
}
