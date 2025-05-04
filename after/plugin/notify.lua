-- just leverage builtin ui attach
require("vim._extui").enable({
    enable = true,
    msg = {
        ---@type 'box'|'cmd'
        pos = "box",
        box = { timeout = 4000 },
    },
})

local title = {
    [vim.log.levels.DEBUG] = " Debug: ",
    [vim.log.levels.ERROR] = " Error: ",
    [vim.log.levels.INFO] = " Info: ",
    [vim.log.levels.TRACE] = " Trace: ",
    [vim.log.levels.WARN] = " Warning: ",
    [vim.log.levels.OFF] = "󰂛 Off: ",
}
local hls = {
    [vim.log.levels.DEBUG] = "NotifyDebug",
    [vim.log.levels.ERROR] = "NotifyError",
    [vim.log.levels.INFO] = "NotifyInfo",
    [vim.log.levels.TRACE] = "NotifyTrace",
    [vim.log.levels.WARN] = "NotifyWarn",
    [vim.log.levels.OFF] = "NotifyOff",
}

---@param msg string
---@param level integer?
---@diagnostic disable-next-line: duplicate-set-field
vim.notify = function(msg, level, _)
    vim.api.nvim_echo(
        {
            { title[level], hls[level] },
            { msg },
        },
        true,
        {
            err = level == vim.log.levels.ERROR,
        }
    )
end
