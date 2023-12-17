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

local function cb(module)
    return function()
        coroutine.resume(coroutine.create(function()
            require("nano.editor." .. module)
        end))
    end
end

local function till_enter_buf(module)
    api.nvim_create_autocmd("BufWinEnter", {
        group = group,
        once = true,
        callback = function()
            if api.nvim_get_current_buf() == 1 and vim.fn.argc() == 0 then
                api.nvim_create_autocmd("BufWinEnter", {
                    group = group,
                    once = true,
                    callback = cb(module)
                })
            else
                cb(module)()
            end
        end
    })
end

local function load_now(module)
    coroutine.resume(coroutine.create(function()
        require("nano.editor." .. module)
    end))
end

-- deals with builtin modules
function M.lazy_load()
    require("nano.colors.moonlight")
    require("nano.builtin.options")
    require("nano.builtin.debug")
    require("nano.builtin.keys")
    require("nano.builtin.autocmd")
    require("nano.builtin.diagnostic")

    load_now("leader")
    load_now("notify")
    load_now("statusline")
    load_now("elegant")

    till_enter_buf("fold")
    till_enter_buf("indentline")
    till_enter_buf("smoothscroll")
    till_enter_buf("squirrel")
    till_enter_buf("term")
end

-- These are for loading packages
function M.on_ft(ft, name, config)
    api.nvim_create_autocmd("Filetype", {
        group = group,
        once = true,
        pattern = ft,
        callback = function()
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
    })
end

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

return M
