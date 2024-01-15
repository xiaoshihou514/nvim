local M = {
    ---@class PluginSpec
    ---@field [1] string
    ---@field event? string
    ---@field cmd? string[]
    ---@field config string
    ---@field build? string
    ---@field lazy? boolean
    ---@type PluginSpec[]
    plugins = {
        -- comment
        { "numToStr/Comment.nvim",                      event = "BufReadPost", config = "comment" },
        -- telescope stuff
        { "nvim-lua/plenary.nvim",                      event = "UIEnter" },
        { "nvim-tree/nvim-web-devicons",                event = "UIEnter" },
        { "nvim-telescope/telescope.nvim",              event = "UIEnter",     config = "telescope" },
        { "nvim-telescope/telescope-file-browser.nvim", event = "UIEnter",     config = "telescope-explorer" },
        -- completion
        { "nvimdev/epo.nvim",                           event = "BufWinEnter", config = "epo" },
        -- hl color codes
        { "echasnovski/mini.hipatterns",                event = "BufReadPost", config = "hipatterns" },
        -- formatting + linting
        { "nvimdev/guard.nvim",                         lazy = true,           config = "guard" },
        -- code context
        { "nvim-treesitter/nvim-treesitter-context",    event = "BufReadPost", config = "treesitter-context" },
        -- install ts parsers easily
        { "nvim-treesitter/nvim-treesitter",            event = "BufReadPost", build = "TSUpdate",           config = "treesitter", },
        -- lsp quickstart
        { "neovim/nvim-lspconfig",                      lazy = true,           config = "lspconfig" },
        -- dap stuff
        { "mfussenegger/nvim-dap",                      lazy = true,           config = "dap" },
        { "rcarriga/nvim-dap-ui",                       lazy = true,           config = "dap-ui" },
        -- language specific
        { "mrcjkb/haskell-tools.nvim",                  lazy = true },
        -- MUST HAVE
        { "seandewar/bad-apple.nvim",                   cmd = { "BadApple" } },
    },
    ---@class Package
    ---@field name string
    ---@field full_name string
    ---@field path string
    ---@field build string
    ---@type Package[]
    all_pkgs = {},
    ---@class Installation
    ---@field name string
    ---@field full_name string
    ---@field path string
    ---@field url string
    ---@field build string
    ---@type Installation[]
    unavailable_pkgs = {},
    ---@class LoadInfo
    ---@field name string
    ---@field event string
    ---@field time integer
    ---@type LoadInfo[]
    loaded = {},
    ---@type table<string, string>
    not_loaded = {},
}

local api = vim.api
local ns = api.nvim_create_namespace("NanoPack")

local function open_float()
    -- dimensions
    local buf = api.nvim_create_buf(false, true)
    local h, w = vim.o.lines, vim.o.columns
    local height, width =
        math.ceil(h * 0.85),
        math.ceil(w * 0.85)

    -- init window
    api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.ceil((h - height) / 2) - 1,
        col = math.ceil((w - width) / 2),
        style = "minimal",
        border = "single",
        title = " NanoPack ",
        title_pos = "center",
        noautocmd = true,
    })
    api.nvim_set_option_value("modifiable", false, { buf = buf })
    vim.keymap.set("n", "q", "<cmd>bdelete<cr>", { buffer = buf })

    -- the buffer modifying function we will use
    local function insert_line(row, line)
        api.nvim_set_option_value("modifiable", true, { buf = buf })
        api.nvim_buf_set_lines(buf, row, row, false, { line })
        api.nvim_set_option_value("modifiable", false, { buf = buf })
    end

    -- header padding
    insert_line(-1, "")
    return { buf, height, width, insert_line }
end

function M.install()
    -- init window
    local buf, _, width, insert_line = unpack(open_float())
    local bar_length = width - 4

    -- title
    insert_line(-1, "  Installing:")
    -- tasks view
    insert_line(-1, "  Tasks: 0 / " .. #M.unavailable_pkgs)
    -- progress bar
    insert_line(-1, "  " .. string.rep("―", bar_length))
    -- another padding
    insert_line(-1, "")
    local state = {
        id = {},
        finished_count = 0,
    }

    for i, missing in ipairs(M.unavailable_pkgs) do
        -- displayed itemm
        insert_line(5 + i, "  " .. missing.full_name)
        vim.fn.mkdir(missing.path, "p")

        -- launch git executable
        vim.system({
            "git",
            "clone",
            "--progress",
            missing.url,
            missing.path
        }, {
            -- we get output from stderr
            stderr = vim.schedule_wrap(function(err, data)
                if not data then return end
                -- show output as an extmark
                state.id[i] = api.nvim_buf_set_extmark(buf, ns, 5 + i, 0, {
                    id = state.id[i],
                    virt_text = not err and { { data, "NvimString" } } or { { err, "Error" } },
                })
            end),
        }, vim.schedule_wrap(function()
            -- update hint
            if missing.build then
                vim.cmd.packadd(missing.name)
                vim.cmd(missing.build)
            end
            api.nvim_buf_set_extmark(buf, ns, 5 + i, 0, {
                id = state.id[i],
                virt_text = { { missing.build and "" or "", "Directory" } }
            })
            -- update progress bar
            api.nvim_buf_add_highlight(buf, ns, "Directory", 4,
                2 + math.floor((state.finished_count / #M.unavailable_pkgs) * bar_length) * 3,
                2 + math.ceil(((state.finished_count + 1) / #M.unavailable_pkgs) * bar_length) * 3
            )
            state.finished_count = state.finished_count + 1
            -- updating task count
            api.nvim_set_option_value("modifiable", true, { buf = buf })
            api.nvim_buf_set_lines(buf, 3, 4, false,
                { "  Tasks: " .. state.finished_count .. " / " .. #M.unavailable_pkgs })
            api.nvim_set_option_value("modifiable", false, { buf = buf })
            -- close ui if finished
            if state.finished_count == #M.unavailable_pkgs then
                vim.defer_fn(function()
                    vim.cmd.bdelete(buf)
                end, 1000)
            end
        end))
    end
end

local packpath = vim.fn.stdpath("data") .. "/site/pack/nano/opt/"
local url_prefix = "https://github.com/"

function M.ensure()
    vim.tbl_map(function(plugin)
        local full_name = plugin[1]
        local name = vim.split(full_name, "/")[2]
        local pkg = {
            name = name,
            full_name = full_name,
            path = packpath .. name,
            url = url_prefix .. full_name,
            build = plugin.build
        }
        table.insert(M.all_pkgs, pkg)
        if vim.fn.isdirectory(pkg.path) == 0 then
            table.insert(M.unavailable_pkgs, pkg)
        end
    end, M.plugins)
    if vim.fn.isdirectory(packpath) == 0 then
        vim.fn.mkdir(packpath, "p")
    end
    if #M.unavailable_pkgs > 0 then
        M.install()
    end
end

function M.update()
    -- init window
    local buf, _, width, insert_line = unpack(open_float())
    local bar_length = width - 4
    bind("n", "H", function()
        vim.cmd.bdelete(buf)
        M.load_status()
    end)

    -- title
    insert_line(-1, "  Updating:")
    -- tasks view
    insert_line(-1, "  Tasks: 0 / " .. #M.all_pkgs)
    -- progress bar
    insert_line(-1, "  " .. string.rep("―", bar_length))
    -- another padding
    insert_line(-1, "")

    local state = {
        id = {},
        finished_count = 0,
    }

    for i, plugin in ipairs(M.all_pkgs) do
        -- displayed itemm
        insert_line(5 + i, "  " .. plugin.full_name)

        -- launch git executable
        vim.system({
            "git",
            "pull",
            "--update-shallow",
            "--ff-only",
            "--progress",
        }, {
            cwd = plugin.path,

            -- we get output from stdout
            stdout = vim.schedule_wrap(function(err, data)
                if not data then return end
                -- show output as an extmark
                state.id[i] = api.nvim_buf_set_extmark(buf, ns, 5 + i, 0, {
                    id = state.id[i],
                    virt_text = not err and { { data, "NvimString" } } or { { err, "Error" } },
                })
            end),

        }, vim.schedule_wrap(function()
            -- update hint
            if plugin.build then
                vim.cmd.packadd(plugin.name)
                vim.cmd(plugin.build)
            end
            api.nvim_buf_set_extmark(buf, ns, 5 + i, 0, {
                id = state.id[i],
                virt_text = { { plugin.build and "" or "", "Directory" } }
            })

            -- update progress bar
            api.nvim_buf_add_highlight(buf, ns, "Directory", 4,
                2 + math.floor((state.finished_count / #M.all_pkgs) * bar_length) * 3,
                2 + math.ceil(((state.finished_count + 1) / #M.all_pkgs) * bar_length) * 3
            )
            state.finished_count = state.finished_count + 1

            -- updating task count
            api.nvim_set_option_value("modifiable", true, { buf = buf })
            api.nvim_buf_set_lines(buf, 3, 4, false, { "  Tasks: " .. state.finished_count .. " / " .. #M.all_pkgs })
            api.nvim_set_option_value("modifiable", false, { buf = buf })
        end))
    end
end

function M.load_status()
    -- init window
    local buf, _, _, insert_line = unpack(open_float())
    bind("n", "U", function()
        vim.cmd.bdelete(buf)
        M.update()
    end)
    -- loaded
    for i, l in ipairs(M.loaded) do
        insert_line(2 + i, ("  ● %s %s ms %s"):format(l.name, l.time, l.event))
        api.nvim_buf_add_highlight(buf, ns, "Directory", 1 + i, 6, 6 + #l.name)
    end
    insert_line(-1, "")
    local cnt, line_start = 0, 3 + #M.loaded
    for name, nl in pairs(M.not_loaded) do
        insert_line(-1, ("  ○ %s %s"):format(name, nl))
        api.nvim_buf_add_highlight(buf, ns, "Directory", line_start + cnt, 6, 6 + #name)
        cnt = cnt + 1
    end
    insert_line(line_start, ("  Not Loaded (%s/%s):"):format(cnt, #M.loaded + cnt))
    insert_line(2, ("  Loaded (%s/%s):"):format(#M.loaded, #M.loaded + cnt))
end

local loader = require("nano.loader")
local perf = require("nano.perf")
loader.load_state(M.loaded, M.not_loaded)

local function create_load_order(plugin)
    local name = vim.split(plugin[1], "/")[2]

    if plugin.event then
        M.not_loaded[name] = " " .. plugin.event
    elseif plugin.cmd then
        M.not_loaded[name] = " " .. table.concat(plugin.cmd, "  ")
    end

    if plugin.event then
        loader.on_event(plugin.event, name, plugin.config)
    elseif plugin.cmd then
        loader.on_cmd(plugin.cmd, name, plugin.config)
    elseif not plugin.lazy then
        local time = perf.record(function()
            vim.cmd.packadd(name)
            if plugin.config then
                require("nano.config." .. plugin.config)
            end
        end)
        table.insert(M.loaded, {
            event = " start",
            time = time,
            name = plugin[1],
        })
    else
        M.not_loaded[name] = " Lazy"
    end
end

function M.lazy_load()
    vim.tbl_map(create_load_order, M.plugins)
end

function M.lazy_load_modules()
    require("nano.builtin.options") -- breaks with UIEnter for some reason
    -- my own modules are pretty fast in terms of load time
    loader.module_on_event("builtin.diagnostic", "UIEnter")
    loader.module_on_event("builtin.autocmd", "UIEnter")

    loader.module_on_event("module.ui", "UIEnter")
    loader.module_on_event("module.fold", "UIEnter")
    loader.module_on_event("module.indentline", "UIEnter")
    loader.module_on_event("module.smoothscroll", "UIEnter")
    loader.module_on_event("module.squirrel", "UIEnter")
    loader.module_on_event("module.statusline", "UIEnter")
    loader.module_on_event("module.term", "UIEnter")

    loader.lazy_load_lang_modules()
end

api.nvim_create_user_command("NanoPack", M.load_status, {})
api.nvim_create_user_command("NanoPackUpdate", M.update, {})

return M
