local M = {}

require("nano.module.ui.input")
require("nano.module.ui.select")
require("nano.module.ui.notify")

local api = vim.api
local ns = api.nvim_create_namespace("NanoUI")
local group = vim.api.nvim_create_augroup("NanoMessages", {})
local notify = vim.notify

-- The following just ensures stuff like nvim_err_writeln also uses our overriden notify
-- Also I added some useful utils for inspecting messages

M.history = {}
M.lsp_data = {}
M.lsp_processing = false

M.events = {
    ext_cmdline = true,
    ext_messages = true,
}

M.kind_to_level = {

}

M.handlers = {
    ["msg_show"]          = function(kind, content, replace_last)
        if kind == "search_count" or "quickfix" then
            return
        end
        if kind == "return_prompt" then
            api.nvim_input("<cr>")
            return
        end
        if kind == "confirm" or kind == "confirm_sc" then
            M.disable()
            vim.schedule(M.enable)
        end
        -- TODO: for echo kinds we should only keep one
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
        -- I know what mode am I in
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

M.on_lsp_progress = function(_, data, info)
    if M.lsp_processing then
        return
    end
    M.lsp_processing = true

    local buf = api.nvim_get_current_buf()
    if not M.lsp_data[buf] then
        M.lsp_data[buf] = {}
    end
    local buf_data = M.lsp_data[buf]
    local token = data.token

    ---@diagnostic disable-next-line: undefined-field
    local name = vim.lsp.get_clients({ bufnr = 0, id = info.client_id })[1].name
    local message = data.value.message
    local perc = data.value.percentage

    if not buf_data[token] then
        if name and message and perc then
            M.lsp_data[buf][token] = notify(
                ("%s: %s (%s%%)"):format(name, message, perc),
                vim.log.levels.INFO,
                {}
            )
        end
    elseif data.value.kind == "report" then
        if name and message and perc then
            notify(
                ("%s: %s (%s%%)"):format(name, message, perc),
                vim.log.levels.INFO,
                { modify_existing = true, modify = buf_data[token] })
        end
    elseif data.value.kind == "end" then
        notify(
            ("%s:  "):format(name),
            vim.log.levels.INFO,
            { modify_existing = true, modify = buf_data[token], close_after = true })
    end
    M.lsp_processing = false
end

-- We don't _really_ want to handle the cmdline events
-- api.nvim_create_autocmd("CmdlineEnter", {
--     group = group,
--     callback = vim.schedule_wrap(M.disable)
-- })
--
-- api.nvim_create_autocmd("CmdlineLeave", {
--     group = group,
--     callback = vim.schedule_wrap(M.enable)
-- })

-- M.enable()
vim.lsp.handlers["$/progress"] = M.on_lsp_progress

return M
