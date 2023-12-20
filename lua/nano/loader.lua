local M = {}
local loaded, not_loaded
local api = vim.api
local perf = require("nano.perf")
local group = api.nvim_create_augroup("NanoPack", {})

-- inject state
function M.load_state(_loaded, _not_loaded)
    loaded = _loaded
    not_loaded = _not_loaded
end

-- These are for loading packages
function M.on_event(event, name, config)
    local cb = function()
        coroutine.resume(coroutine.create(function()
            local time = perf.record(function()
                vim.cmd.packadd(name)
                if config then
                    require("nano.config." .. config)
                end
            end)
            table.insert(loaded, {
                event = not_loaded[name],
                time = time,
                name = name,
            })
            not_loaded[name] = nil
        end))
    end
    if event == "BufWinEnter" then
        api.nvim_create_autocmd("BufWinEnter", {
            group = group,
            once = true,
            callback = function()
                if api.nvim_get_current_buf() == 1 and vim.fn.argc() == 0 then
                    api.nvim_create_autocmd("BufWinEnter", {
                        group = group,
                        once = true,
                        callback = cb
                    })
                else
                    cb()
                end
            end
        })
        return
    end
    api.nvim_create_autocmd(event, {
        group = group,
        once = true,
        callback = cb
    })
end

function M.on_cmd(cmds, name, config)
    for _, cmd in ipairs(cmds) do
        api.nvim_create_user_command(cmd, function()
            api.nvim_del_user_command(cmd)
            local time = perf.record(function()
                vim.cmd.packadd(name)
                if config then
                    require("nano.config." .. config)
                end
            end)
            table.insert(loaded, {
                event = not_loaded[name],
                time = time,
                name = name,
            })
            not_loaded[name] = nil
            vim.cmd(cmd)
        end, {})
    end
end

-- for loading modules
function M.module_on_event(name, event)
    local cb = function()
        coroutine.resume(coroutine.create(function()
            local time = perf.record(function()
                require("nano." .. name)
            end)
            table.insert(loaded, {
                event = not_loaded[name],
                time = time,
                name = name,
            })
            not_loaded[name] = nil
        end))
    end
    not_loaded[name] = " " .. event
    if event == "BufWinEnter" then
        api.nvim_create_autocmd("BufWinEnter", {
            group = group,
            once = true,
            callback = function()
                if api.nvim_get_current_buf() == 1 and vim.fn.argc() == 0 then
                    api.nvim_create_autocmd("BufWinEnter", {
                        group = group,
                        once = true,
                        callback = cb
                    })
                else
                    cb()
                end
            end
        })
        return
    end
    api.nvim_create_autocmd(event, {
        group = group,
        once = true,
        callback = cb
    })
end

-- TODO HACK
local loaded_lsp, loaded_guard, loaded_dap = false, false, false
local default_cap
local guard = {}
local dap

local function load_lsp()
    if not loaded_lsp then
        local time = perf.record(function()
            vim.cmd.packadd("epo.nvim")
            vim.cmd.packadd("nvim-lspconfig")

            require("lspconfig.ui.windows").default_options.border = "single"
            require("lspconfig.ui.windows").default_options.winhighlight = "FloatBorder:Normal"
            default_cap = vim.tbl_deep_extend("force",
                vim.lsp.protocol.make_client_capabilities(),
                require("epo").register_cap()
            )
        end)
        table.insert(loaded, {
            event = not_loaded["nvim-lspconfig"],
            time = time,
            name = "nvim-lspconfig",
        })
        not_loaded["nvim-lspconfig"] = nil
        loaded_lsp = true
    end

    return {
        require("lspconfig"),
        default_cap,
    }
end

local function load_guard()
    if not loaded_guard then
        local time = perf.record(function()
            vim.cmd.packadd("guard.nvim")
        end)
        table.insert(loaded, {
            event = not_loaded["guard.nvim"],
            time = time,
            name = "guard.nvim",
        })
        not_loaded["guard.nvim"] = nil
        guard.filetype = require("guard.filetype")
        guard.lint = require("guard.lint")
        guard.events = require("guard.events")
        guard.format = require("guard.format")
        loaded_guard = true
    end
    return {
        guard.filetype,
        guard.lint
    }
end

local function load_dap()
    if not loaded_dap then
        local time = perf.record(function()
            vim.cmd.packadd("nvim-dap")
        end)
        table.insert(loaded, {
            event = not_loaded["nvim-dap"],
            time = time,
            name = "nvim-dap",
        })
        not_loaded["nvim-dap"] = nil
        local time_ = perf.record(function()
            vim.cmd.packadd("nvim-dap-ui")
        end)
        table.insert(loaded, {
            event = not_loaded["nvim-dap-ui"],
            time = time_,
            name = "nvim-dap-ui",
        })
        not_loaded["nvim-dap-ui"] = nil
        dap = require("dap")
        ---@diagnostic disable-next-line: different-requires
        require("nano.config.dap")
        require("nano.config.dap-ui")
        loaded_dap = true
    end
    return dap
end

local function lsp_cb()
    api.nvim_command("LspStart")
end

local function guard_cb(ft)
    local conf = guard.filetype[ft]
    guard.format.attach_to_buf(0)
    guard.events.create_lspattach_autocmd(true)
    local lint_events = { "BufWritePost", "BufEnter" }

    if conf.formatter then
        guard.events.watch_ft(ft)
        lint_events[1] = "User GuardFmt"
    end

    for i, _ in ipairs(conf.linter) do
        if conf.linter[i].stdin then
            table.insert(lint_events, "TextChanged")
            table.insert(lint_events, "InsertLeave")
        end
        guard.lint.register_lint(ft, lint_events)
    end
end

function M.load_lang_modules()
    for ft, setup in pairs(require("nano.lang")) do
        api.nvim_create_autocmd("Filetype", {
            group = group,
            pattern = ft,
            once = true,
            callback = function()
                setup(load_lsp, load_guard, load_dap, lsp_cb, guard_cb)
            end
        })
    end
end

return M
