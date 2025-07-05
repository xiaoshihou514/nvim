-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/dartls.lua
return {
    cmd = { "dart", "language-server", "--protocol=lsp" },
    root_markers = root_patterns.dart,
    filetypes = { "dart" },
    init_options = {
        onlyAnalyzeProjectsWithOpenFiles = true,
        suggestFromUnimportedLibraries = true,
        closingLabels = true,
        outline = true,
        flutterOutline = true,
    },
    settings = {
        dart = {
            completeFunctionCalls = true,
            showTodos = true,
        },
    },
}
