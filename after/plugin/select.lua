local api = vim.api

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(items, opts, on_choice)
    local height, width = vim.o.lines, vim.o.columns
    local buf = api.nvim_create_buf(false, true)
    local win = api.nvim_open_win(buf, true, {
        relative = "editor",
        row = math.floor(height * 0.25),
        col = math.floor(width * 0.25),
        height = math.ceil(height * 0.5),
        width = math.ceil(width * 0.5),
    })
    local bufopts = {
        bufhidden = "delete",
        matchpairs = "",
        buflisted = false,
        cursorcolumn = false,
        cursorline = false,
        list = false,
        number = false,
        relativenumber = false,
        spell = false,
        swapfile = false,
        readonly = false,
        filetype = "dashboard",
        wrap = false,
        signcolumn = "no",
        scrolloff = 0,
        winbar = " ",
    }
    for opt, val in pairs(bufopts) do
        api.nvim_set_option_value(opt, val, { scope = "local" })
    end
    local fmt = opts.format_item or function(x)
        return x
    end
    local formatted = vim.tbl_map(fmt, items)
    local id = vim.fn.termopen(
        [[cat | fzf \
        --layout=reverse --border=sharp
    ]],
        {
            clear_env = true,
            env = { FZF_DEFAULT_COMMAND = "fd -H --type f --strip-cwd-prefix" },
            on_exit = function(_, code, _)
                if code ~= 0 then
                    api.nvim_win_close(win, true)
                    on_choice(nil)
                    return
                end
                local line = vim.iter(api.nvim_buf_get_lines(buf, 0, -1, false))
                    :rev()
                    :find(function(ln)
                        return ln ~= ""
                    end)
                api.nvim_win_close(win, true)
                local idx = 1 + vim.fn.index(formatted, line)
                on_choice(items[idx], idx)
            end,
        }
    )
    api.nvim_chan_send(id, table.concat(formatted, "\n"))
    -- close stdin with C-d
    api.nvim_chan_send(id, "\n\x04")
    api.nvim_command("silent! startinsert")
end
