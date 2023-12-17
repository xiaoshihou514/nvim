local ft = {
    lsp = { "lua", "rust", "haskell", "tex", "plaintex", "bib", "c", "cpp", "python", "kotlin", "groovy" },
    dap = { "haskell", "kotlin" },
    ts = { "bash", "fish", "c", "haskell", "kotlin", "lua", "markdown", "python", "query", "vim", "vimdoc" },
    src = { "lua", "vim", "rust", "html", "json", "yaml", "c", "cpp", "python", "haskell", "kotlin", "bash", "fish", "haskell", "lhaskell" },
    fmt_lint = { "lua", "rust", "html", "markdown", "json", "yaml", "tex", "plaintex", "bib", "c", "cpp", "python", "fish", "haskell", "kotlin" },
}

local M = {
    plugins = {
        -- comment
        { "numToStr/Comment.nvim",                      event = "BufWinEnter", config = "comment" },
        -- autopair
        { "windwp/nvim-autopairs",                      event = "InsertEnter", config = "autopair" },
        -- telescope stuff
        { "nvim-lua/plenary.nvim",                      event = "UIEnter" },
        { "nvim-tree/nvim-web-devicons",                event = "UIEnter" },
        { "nvim-telescope/telescope.nvim",              event = "UIEnter",     config = "telescope" },
        { "nvim-telescope/telescope-file-browser.nvim", event = "UIEnter",     config = "telescope-explorer" },
        -- mason
        {
            "williamboman/mason.nvim",
            cmd = {
                "Mason",
                "MasonInstall",
                "MasonLog",
                "MasonUninstall",
                "MasonUninstallAll",
                "MasonUpdate",
            },
            build = "MasonUpdate",
            config = "mason"
        },
        -- completion
        { "nvimdev/epo.nvim",                        event = "LspAttach",   config = "epo" },
        -- hl color codes
        { "echasnovski/mini.hipatterns",             event = "BufWinEnter", config = "hipatterns" },
        -- scrollbar
        { "lewis6991/satellite.nvim",                event = "BufWinEnter", config = "satellite" },
        -- formatting + linting
        { "nvimdev/guard.nvim",                      ft = ft.fmt_lint,      config = "guard" },
        -- code context
        { "nvim-treesitter/nvim-treesitter-context", ft = ft.src,           config = "tresitter-context" },
        -- install ts parsers easily
        { "nvim-treesitter/nvim-treesitter",         ft = ft.ts,            build = "TSUpdate",          config = "treesitter", },
        -- lsp quickstart
        { "neovim/nvim-lspconfig",                   ft = ft.lsp,           config = "lspconfig" },
        -- dap stuff
        { "mfussenegger/nvim-dap",                   ft = ft.dap,           config = "dap" },
        { "rcarriga/nvim-dap-ui",                    ft = ft.dap,           config = "dap-ui" },
        -- MUST HAVE
        { "seandewar/bad-apple.nvim",                cmd = { "BadApple" } },
    },
    ---@type { name: string, full_name: string, path: string, build: string }
    all = {},
    ---@type { name: string, full_name: string, path: string, build: string }
    unavailable = {},
    ---@type { name: string, event: string, time: integer }
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
    bind("n", "q", "<cmd>bdelete<cr>", { buffer = buf })

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
    insert_line(-1, "  Tasks: 0 / " .. #M.unavailable)
    -- progress bar
    insert_line(-1, "  " .. string.rep("―", bar_length))
    -- another padding
    insert_line(-1, "")
    local state = {
        id = {},
        finished_count = 0,
    }

    for i, missing in ipairs(M.unavailable) do
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
                2 + math.floor((state.finished_count / #M.unavailable) * bar_length) * 3,
                2 + math.ceil(((state.finished_count + 1) / #M.unavailable) * bar_length) * 3
            )
            state.finished_count = state.finished_count + 1
            -- updating task count
            api.nvim_set_option_value("modifiable", true, { buf = buf })
            api.nvim_buf_set_lines(buf, 3, 4, false, { "  Tasks: " .. state.finished_count .. " / " .. #M.unavailable })
            api.nvim_set_option_value("modifiable", false, { buf = buf })
            -- close ui if finished
            if state.finished_count == #M.unavailable then
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
        table.insert(M.all, pkg)
        if vim.fn.isdirectory(pkg.path) == 0 then
            table.insert(M.unavailable, pkg)
        end
    end, M.plugins)
    if vim.fn.isdirectory(packpath) == 0 then
        vim.fn.mkdir(packpath, "p")
    end
    if #M.unavailable > 0 then
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
    insert_line(-1, "  Tasks: 0 / " .. #M.all)
    -- progress bar
    insert_line(-1, "  " .. string.rep("―", bar_length))
    -- another padding
    insert_line(-1, "")

    local state = {
        id = {},
        finished_count = 0,
    }

    for i, plugin in ipairs(M.all) do
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
                2 + math.floor((state.finished_count / #M.all) * bar_length) * 3,
                2 + math.ceil(((state.finished_count + 1) / #M.all) * bar_length) * 3
            )
            state.finished_count = state.finished_count + 1

            -- updating task count
            api.nvim_set_option_value("modifiable", true, { buf = buf })
            api.nvim_buf_set_lines(buf, 3, 4, false, { "  Tasks: " .. state.finished_count .. " / " .. #M.all })
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
    -- title
    insert_line(-1, ("  Loaded (%s/%s):"):format(#M.loaded, #M.all))
    -- loaded
    for i, plugin in ipairs(M.loaded) do
        insert_line(2 + i, ("  ● %s %s ms %s"):format(plugin.name, plugin.time, plugin.event))
        api.nvim_buf_add_highlight(buf, ns, "Directory", 2 + i, 6, 6 + #plugin.name)
    end
    insert_line(-1, "")
    local cnt, line_start = 0, 4 + #M.loaded
    for name, load_cond in pairs(M.not_loaded) do
        insert_line(-1, ("  ○ %s %s"):format(name, load_cond))
        api.nvim_buf_add_highlight(buf, ns, "Directory", line_start + cnt, 6, 6 + #name)
        cnt = cnt + 1
    end
    insert_line(line_start, ("  Not Loaded (%s/%s):"):format(cnt, #M.all))
end

local loader = require("nano.loader")
local perf = require("nano.perf")
loader.load_state(M.loaded, M.not_loaded)

local function create_load_order(plugin)
    local name = vim.split(plugin[1], "/")[2]
    if plugin.ft then
        M.not_loaded[name] = (" %s"):format(#plugin.ft)
    elseif plugin.event then
        M.not_loaded[name] = " " .. plugin.event
    elseif plugin.cmd then
        M.not_loaded[name] = " " .. table.concat(plugin.cmd, "  ")
    end
    if plugin.ft then
        loader.on_ft(plugin.ft, name, plugin.config)
    elseif plugin.event then
        loader.on_event(plugin.event, name, plugin.config)
    elseif plugin.cmd then
        loader.on_cmd(plugin.cmd, name, plugin.config)
    else
        coroutine.resume(coroutine.create(function()
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
        end))
    end
end

function M.lazy_load()
    vim.tbl_map(create_load_order, M.plugins)
end

api.nvim_create_user_command("NanoPack", M.load_status, {})
api.nvim_create_user_command("NanoPackUpdate", M.update, {})

return M
