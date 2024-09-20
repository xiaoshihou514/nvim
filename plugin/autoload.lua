_G.root_patterns = {
    ".git",
    ".editorconfig",
    "build.sbt",
    "project.scala",
    "build.zig",
    "Cargo.toml",
    "stylua.toml",
    "*.cabal",
    "CMakeList.txt",
    "Makefile",
    "pubspec.yaml",
    "package.json",
    "go.mod",
}

_G.lsp_default_config = {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    on_attach = function(client, buf)
        if client.server_capabilities.completionProvider then
            vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
        end
        vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = buf })
        -- https://github.com/glepnir/nvim/blob/main/lua/internal/completion.lua
        vim.api.nvim_create_autocmd("InsertCharPre", {
            buffer = buf,
            callback = function()
                if tonumber(vim.fn.pumvisible()) ~= 0 then
                    return
                end
                if #vim.lsp.get_clients({ bufnr = buf }) == 0 then
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
                    vim.lsp.completion.trigger()
                end
            end,
        })
    end,
}

_G.bind = function(mode, key, binding, opts)
    vim.keymap.set(mode, key, binding, opts or {})
end

---@diagnostic disable: inject-field
vim.g.mapleader = " "
vim.g.maplocalleader = " "
