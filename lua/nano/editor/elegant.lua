-- hugely debloated version of dressing.nvim (1k LOC -> 123 LOC)

local api, set = vim.api, vim.api.nvim_set_option_value
local ns = api.nvim_create_namespace("elegant")
local group = api.nvim_create_augroup("Elegant", {})

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require("telescope.actions")

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.input = function(opts, on_confirm)
    local mode = vim.fn.mode()
    -- setup window according to spec
    local buf = api.nvim_create_buf(true, false)
    local win = api.nvim_open_win(buf, true, {
        relative = "cursor",
        width = math.max(40, api.nvim_strwidth(opts.prompt or "")),
        anchor = "SW",
        row = 0,
        col = 0,
        height = 1,
        style = "minimal",
        border = "single",
        title = opts.prompt or "Input",
        noautocmd = true,
    })
    set("wrap", false, { win = win })
    set("number", false, { win = win })
    set("relativenumber", false, { win = win })
    set("winhl", "Normal:Terminal", { win = win })
    set("filetype", "elegant", { buf = buf })
    set("tabstop", 1, { buf = buf })
    if opts.completion then
        _G.elegant_cfu = function(findstart, base)
            if findstart == 1 then
                return 0
            end
            local ok, result = pcall(vim.fn.getcompletion, base, opts.completion)
            return ok and result or {}
        end
        set("completefunc", "v:lua.elegant_cfu", { buf = buf })
    end
    if opts.highlight then
        api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
            buffer = buf,
            group = group,
            callback = function(opt)
                local hls
                local text = api.nvim_buf_get_lines(opt.buf, 0, -1, false)
                if type(opts.highlight) == "function" then
                    hls = opts.highlight(text)
                elseif vim.fn[opts.highlight] then
                    hls = vim.fn[opts.highlight](text)
                end
                api.nvim_buf_clear_namespace(opt.buf, ns, 0, -1)
                if hls then
                    for _, hl in ipairs(hls) do
                        api.nvim_buf_add_highlight(opt.buf, ns, hl[3], 0, hl[1], hl[2])
                    end
                end
            end,
        })
    end
    -- prepare for input
    if opts.default then
        api.nvim_buf_set_lines(buf, 0, -1, false, { opts.default })
    end
    bind({ "i", "n" }, "<Esc>", function()
        api.nvim_buf_delete(buf, { force = true })
        if mode == "n" then
            api.nvim_input("<Esc>l")
        end
        on_confirm(nil)
    end, { buffer = buf })
    bind({ "i", "n" }, "<cr>", function()
        local text = api.nvim_buf_get_lines(buf, 0, -1, false)[1]
        api.nvim_buf_delete(buf, { force = true })
        if mode == "n" then
            api.nvim_input("<Esc>l")
        end
        on_confirm(text)
    end, { buffer = buf })
    bind("i", "<Tab>", function()
        if vim.fn.pumvisible() == 1 then
            return api.nvim_replace_termcodes("<C-n>", true, false, true)
        else
            return api.nvim_replace_termcodes("<C-x><C-u>", true, false, true)
        end
    end, { noremap = true, expr = true, buffer = buf })
    bind("i", "<S-Tab>", "<C-p>", { noremap = true, buffer = buf })
    api.nvim_input("<End>")
    vim.cmd.startinsert()
end

---@diagnostic disable-next-line: duplicate-set-field
vim.ui.select = function(items, opts, on_choice)
    local telescope_opts = {
        prompt_title = opts.prompt or "",
        previewer = false,
        sorter = conf.generic_sorter({}),
        finder = finders.new_table({
            results = items,
            entry_maker = function(item)
                local fmt = opts.format_item or vim.inspect
                local formatted = fmt(item)
                return {
                    display = formatted,
                    ordinal = formatted,
                    value = item,
                }
            end,
        }),
        attach_mappings = function(buf)
            actions.select_default:replace(function()
                local selection = require("telescope.actions.state").get_selected_entry()
                -- to prevent calling it twice
                local cb = on_choice
                on_choice = function() end
                actions.close(buf)
                if not selection then
                    cb(nil, nil)
                else
                    cb(items[selection.index], selection.index)
                end
            end)
            actions.close:enhance({
                post = function()
                    on_choice(nil, nil)
                end,
            })
            return true
        end,
    }
    pickers.new(require("telescope.themes").get_dropdown(), telescope_opts):find()
end
