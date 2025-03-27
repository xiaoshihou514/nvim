return {
    cmd = { "basedpyright-langserver", "--stdio" },
    root_markers = root_patterns.python,
    filetypes = { "python" },
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
            },
        },
    },
}
