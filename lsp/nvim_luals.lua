return {
    cmd = { "lua-language-server" },
    root_markers = root_patterns.lua,
    filetypes = { "lua" },
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    },
}
