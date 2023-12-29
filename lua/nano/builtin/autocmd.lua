local api = vim.api
local augroup = api.nvim_create_augroup("Xiaoshihou", {})
local function autocmd(ev, opts)
    opts.group = augroup
    api.nvim_create_autocmd(ev, opts)
end

autocmd("TextYankPost", {
    desc = "Highlight yanking region when yanking inplicitly using y*",
    callback = function()
        vim.highlight.on_yank({ higroup = "OnYank" })
    end,
})

autocmd("BufReadPost", {
    desc = "Return to last line pos and center cursor",
    callback = function()
        local mark = api.nvim_buf_get_mark(0, '"')
        local line_count = api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(api.nvim_win_set_cursor, 0, mark)
            api.nvim_input("z.")
        end
    end,
})

autocmd("BufWinEnter", {
    desc = "better commenting rules",
    callback = function()
        vim.opt.fo = vim.opt.fo - "o" - "2" + "r" + "c" + "j"
    end,
})

autocmd("BufEnter", {
    desc = "Go to project root",
    callback = function()
        if
            vim.tbl_contains({
                "help",
                "dashboard",
                "lazy",
                "mason",
                "TelescopePrompt",
                "nofile",
                "lspinfo",
                "floatterm",
                "elegant",
                "dapui_scopes",
                "dapui_stacks",
                "dapui_console",
                "dapui_watches",
                "",
            }, vim.bo.filetype)
        then
            return
        end
        local cwd = (api.nvim_buf_get_name(0)):match("(.*)/")
        -- try to find a file that's supposed to be in the root
        local patterns = {
            ".git",
            ".luarc.json",
            "Cargo.toml",
            "*.cabal",
            "go.mod",
            "CMakeList.txt",
            "package.json",
        }
        local result = vim.fs.find(patterns, { path = cwd, upward = true, stop = vim.env.HOME })
        if not vim.tbl_isempty(result) then
            vim.cmd.lcd((result[1]):match("(.*)/"))
            return
        end
        -- or if it's some wierd filtype try to get root from lsp
        vim.tbl_map(function(client)
            local filetypes, root = client.config.filetypes, client.config.root_dir
            if filetypes and vim.fn.index(filetypes, vim.bo.ft) ~= -1 and root then
                vim.cmd.lcd(root)
                return
            end
        end, vim.lsp.get_clients({ buf = 0 }))
        vim.cmd.lcd(cwd)
    end,
})

autocmd("BufWritePost", {
    desc = "Automatically compile spell files",
    pattern = "spell/*.add",
    command = "silent! mkspell! %",
})

autocmd("BufWritePost", {
    desc = "autosource colorschme",
    pattern = "colors/*.lua",
    command = "source %"
})

autocmd("LspAttach", {
    desc = "enable inlay hints",
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        vim.lsp.inlay_hint.enable(bufnr, true)
        ---@diagnostic disable-next-line: need-check-nil, undefined-field
        if client.supports_method("textDocument/inlayHint") then
            autocmd("InsertEnter", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.inlay_hint.enable(bufnr, false)
                end
            })
            autocmd("InsertLeave", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.inlay_hint.enable(bufnr, true)
                end
            })
        end
    end
})
