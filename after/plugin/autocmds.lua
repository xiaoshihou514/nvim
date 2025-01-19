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
    desc = "Return to last edit pos",
    callback = function()
        local mark = api.nvim_buf_get_mark(0, '"')
        local line_count = api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[2] <= line_count then
            pcall(api.nvim_win_set_cursor, 0, mark)
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
        local bufname = api.nvim_buf_get_name(0)
        ---@diagnostic disable-next-line: undefined-field
        if not vim.uv.fs_stat(bufname) then
            return
        end
        local cwd = vim.fs.dirname(bufname)
        -- try to find a file that's supposed to be in the root
        local patterns = root_patterns
        local result =
            vim.fs.find(patterns, { path = cwd, upward = true, stop = vim.env.HOME })
        if not vim.tbl_isempty(result) then
            vim.cmd.lcd(vim.fs.dirname(result[1]))
            return
        end
        -- or if it's some wierd filtype try to get root from lsp
        vim.tbl_map(function(client)
            local filetypes, root = client.config.filetypes, client.config.root_dir
            if
                filetypes
                and vim.fn.index(filetypes, vim.bo.ft) ~= -1
                and root
                and root ~= ""
            then
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
    command = "source %",
})

autocmd("VimLeavePre", {
    desc = "clean up after metals",
    callback = function()
        for _, buf in ipairs(api.nvim_list_bufs()) do
            if vim.bo[buf].ft == "scala" then
                api.nvim_command("silent! !kill (psa bloop | awk '{print $2}')")
            end
        end
    end,
})

autocmd("User", {
    desc = "dirty fix for neovim bug",
    pattern = "GuardFmt",
    callback = function(opt)
        if opt.data.status ~= "done" then
            return
        end
        if vim.lsp.get_clients({ bufnr = 0 }) then
            vim.diagnostic.show(nil, 0, nil, nil)
        end
    end,
})
