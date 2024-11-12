local api = vim.api

api.nvim_create_user_command("Dired", function(opts)
    local cwd = opts.fargs[1] and vim.fn.expand(opts.fargs[1]) or vim.fn.getcwd()
    local screen_height, screen_width = vim.o.lines, vim.o.columns
    local height = math.floor(screen_height * 0.8)
    local width = math.max(math.ceil(screen_width * 0.6), 65)
    local pad_top = math.ceil((screen_height - height) / 2)
    local pad_side = math.floor((screen_width - width) / 2)
    api.nvim_open_win(api.nvim_create_buf(false, true), true, {
        relative = "editor",
        row = pad_top,
        col = pad_side,
        height = height,
        width = width,
        border = "single",
    })
    api.nvim_command("silent! lcd " .. cwd)
    vim.bo.ft = "dired"
end, { nargs = "?" })

bind("n", "<leader>e", "<cmd>Dired %:p:h<cr>")

-- https://github.com/nvim-telescope/telescope-file-browser.nvim/blob/master/lua/telescope/_extensions/file_browser/config.lua#L73
local netrw_bufname
api.nvim_create_autocmd("BufEnter", {
    group = api.nvim_create_augroup("Dired", {}),
    desc = "Hijack netrw",
    pattern = "*",
    callback = vim.schedule_wrap(function()
        if vim.bo[0].filetype == "netrw" then
            return
        end
        local bufname = vim.api.nvim_buf_get_name(0)
        if vim.fn.isdirectory(bufname) == 0 then
            _, netrw_bufname = pcall(vim.fn.expand, "#:p:h")
            return
        end

        -- prevents reopening of file-browser if exiting without selecting a file
        if netrw_bufname == bufname then
            netrw_bufname = nil
            return
        else
            netrw_bufname = bufname
        end

        -- ensure no buffers remain with the directory name
        api.nvim_set_option_value("bufhidden", "wipe", { buf = 0 })

        vim.cmd("Dired %:p:h")
    end),
})
