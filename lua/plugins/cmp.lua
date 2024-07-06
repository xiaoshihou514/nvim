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
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-buffer",
    },
    event = "InsertEnter",
    config = function()
        _G.lsp_default_cap = require("cmp_nvim_lsp").default_capabilities()
    end,
    opts = function()
        local cmp = require("cmp")
        return {
            snippet = {
                expand = function(args)
                    return vim.snippet.expand(args.body)
                end,
            },
            window = {
                completion = {
                    border = "single",
                    winhighlight = "Normal:CmpNormal",
                },
                documentation = {
                    border = "single",
                    winhighlight = "Normal:CmpNormal",
                },
            },
            formatting = {
                format = function(_, vim_item)
                    vim_item.kind = (cmp_kinds[vim_item.kind] or "")
                    return vim_item
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(), -- manually trigger completion
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }), -- accept completion
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if vim.snippet.active({ direction = 1 }) then
                        vim.snippet.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if vim.snippet.active({ direction = -1 }) then
                        vim.snippet.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "nvim_lsp_signature_help" },
                { name = "buffer" },
            }),
        }
    end,
}
