local api, lsp = vim.api, vim.lsp

vim.opt.pumheight = 15 -- prevents massive pummenu
vim.opt.completeopt = "menu,menuone,noinsert,fuzzy,popup,noselect" -- pum settings
vim.opt.pumblend = 0 -- no transparency

-- stylua: ignore start
local ascii = {
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
    "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
    "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
}
-- stylua: ignore end

api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        -- setup keybind
        bind("n", "gr", lsp.buf.rename, { buffer = args.buf })
        bind("n", "go", lsp.buf.code_action, { buffer = args.buf })
        bind("n", "gd", lsp.buf.definition, { buffer = args.buf })
        bind("n", "gi", lsp.buf.references, { buffer = args.buf })
        bind("n", "gl", vim.diagnostic.open_float, { buffer = args.buf })
        bind("n", "gs", lsp.buf.signature_help, { buffer = args.buf })
        bind(
            "n",
            "gdl",
            "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>",
            { buffer = args.buf }
        )
        bind(
            "n",
            "gdj",
            "<cmd>split | lua vim.lsp.buf.definition()<cr>",
            { buffer = args.buf }
        )

        local client = assert(lsp.get_client_by_id(args.data.client_id))

        -- trigger compl more often
        local tcs = vim.tbl_get(
            client,
            "server_capabilities",
            "completionProvider",
            "triggerCharacters"
        )
        if tcs then
            client.server_capabilities.completionProvider.triggerCharacters =
                vim.tbl_extend("keep", tcs, ascii)
        end
        lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

        -- TODO: remove when this is in core
        local cancel_prev = function() end
        api.nvim_create_autocmd("CompleteChanged", {
            buffer = args.buf,
            callback = function()
                cancel_prev()
                local info = vim.fn.complete_info({ "selected" })
                local completionItem = vim.tbl_get(
                    vim.v.completed_item,
                    "user_data",
                    "nvim",
                    "lsp",
                    "completion_item"
                )
                if nil == completionItem then
                    return
                end
                _, cancel_prev = lsp.buf_request(
                    args.buf,
                    lsp.protocol.Methods.completionItem_resolve,
                    completionItem,
                    function(_, item, _)
                        if not item then
                            return
                        end
                        local win = api.nvim__complete_set(
                            info["selected"],
                            { info = (item.documentation or {}).value }
                        )
                        if win.winid and api.nvim_win_is_valid(win.winid) then
                            vim.treesitter.start(win.bufnr, "markdown")
                            vim.wo[win.winid].conceallevel = 3
                        end
                    end
                )
            end,
        })

        -- enable lsp fold if supported
        if client:supports_method("textDocument/foldingRange") then
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.lsp.foldexpr()"
        end
    end,
})

-- some helper commands
local function command(name, f)
    api.nvim_create_user_command(name, f, {})
end

command("LspFmt", function()
    lsp.buf.format({ async = true })
end)
command("LspLog", function()
    vim.cmd("tabedit " .. vim.fn.stdpath("state") .. "/lsp.log")
end)
command("LspInfo", function()
    vim.cmd("checkhealth lsp")
end)

-- lsp configuration
lsp.config("*", {
    capabilities = lsp.protocol.make_client_capabilities(),
})

local lsps = { "basedpyright", "clangd", "hls", "nvim_luals", "rust_analyzer" }

for _, name in ipairs(lsps) do
    if vim.fn.executable(lsp.config[name].cmd[1]) == 1 then
        lsp.enable(name)
    end
end
