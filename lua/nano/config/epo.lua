local bind = vim.keymap.set

bind({ "n", "i" }, "<TAB>", function()
    if vim.snippet.jumpable(1) then
        return "<cmd>lua vim.snippet.jump(1)<cr>"
    else
        return "<TAB>"
    end
end, { expr = true })

bind({ "n", "i" }, "<S-TAB>", function()
    if vim.snippet.jumpable(-1) then
        return "<cmd>lua vim.snippet.jump(-1)<CR>"
    else
        return "<S-TAB>"
    end
end, { expr = true })

bind("i", "<C-e>", function()
    if vim.fn.pumvisible() == 1 then
        require("epo").disable_trigger()
    end
    return "<End>"
end, { expr = true })

local kind_icons = {
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰘧",
    Constructor = "",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = " ",
    Unknown = " ",
}

require("epo").setup({
    fuzzy = false,
    debounce = 50,
    signature = true,
    snippet_path = nil,
    signature_border = "single",
    kind_format = function(k)
        return kind_icons[k]
    end
})
