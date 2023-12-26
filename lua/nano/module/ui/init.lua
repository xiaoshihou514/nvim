local M = {}

require("nano.module.ui.input")
require("nano.module.ui.select")
require("nano.module.ui.notify")

local api = vim.api
local ns = api.nvim_create_namespace("NanoUI")
local group = vim.api.nvim_create_augroup("messages_ui", {})
local notify = vim.notify

M.history = {}

M.events = {
    ext_cmdline = true,
    ext_messages = true,
}

M.handlers = {
    ["msg_show"]          = function(kind, content, replace_last)
    end,
    ["msg_clear"]         = function()
    end,
    ["msg_ruler"]         = function()
        -- I don't use the ruler
    end,
    ["msg_showcmd"]       = function()
        -- I don't want to see the last command all the time
    end,
    ["msg_showmode"]      = function()
    end,
    ["msg_history_show"]  = function()
    end,
    ["msg_history_clear"] = function()
    end
}

M.handle = function(event, ...)
    M.handlers[event](...)
end

M.enable = function()
    vim.ui_attach(ns, M.events, M.handle)
end

M.disable = function()
    vim.ui_detach(ns)
    vim.cmd.redraw()
end

-- We don't _really_ want to handle the cmdline events
api.nvim_create_autocmd("CmdlineEnter", {
    group = group,
    callback = vim.schedule_wrap(M.disable)
})

api.nvim_create_autocmd("CmdlineLeave", {
    group = group,
    callback = vim.schedule_wrap(M.enable)
})

M.enable()

return M
