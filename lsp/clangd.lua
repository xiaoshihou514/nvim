local fts = { "c", "cpp" }

return {
    cmd = { "clangd", "--background-index" },
    root_markers = root_patterns[fts],
    filetypes = fts,
    capabilities = {
        offsetEncoding = { "utf-8", "utf-16" },
        textDocument = {
            completion = {
                editsNearCursor = true,
            },
        },
    },
}
