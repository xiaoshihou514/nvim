-- Mostly just https://github.com/glepnir/nvim/blob/main/lua/internal/completion.lua
local api, completion, lsp = vim.api, vim.lsp.completion, vim.lsp
local au = api.nvim_create_autocmd
local group = api.nvim_create_augroup("AutoComplete", { clear = true })

-- completion on word which not exist in lsp client triggerCharacters
local function auto_trigger(bufnr, client)
    au("InsertCharPre", {
        buffer = bufnr,
        group = group,
        callback = function()
            if vim.fn.pumvisible() ~= 0 then
                return
            end
            local triggerchars = vim.tbl_get(
                client,
                "server_capabilities",
                "completionProvider",
                "triggerCharacters"
            ) or {}
            if
                vim.v.char:match("[%w_]")
                and not vim.list_contains(triggerchars, vim.v.char)
            then
                vim.schedule(completion.trigger)
            end
        end,
    })
end

au("LspAttach", {
    group = group,
    callback = function(args)
        local bufnr = args.buf
        local client = lsp.get_client_by_id(args.data.client_id)
        if not client or not client:supports_method("textDocument/completion") then
            return
        end

        completion.enable(true, client.id, bufnr, { autotrigger = true })

        if
            #api.nvim_get_autocmds({
                buffer = bufnr,
                event = "InsertCharPre",
                group = group,
            }) == 0
        then
            auto_trigger(bufnr, client)
        end
    end,
})
