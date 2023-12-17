-- load time tracking module
local perf = require("nano.perf")
-- Fire up dashboard ASAP to minimize visual delay
vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
        if vim.fn.argc() == 0 then
            require("nano.editor.dashboard")(perf.cputime())
        else
            require("nano.editor.dashboard")
        end
    end
})
-- ensure all specified plugins are installed
require("nano.pack").ensure()
-- (lazy) load plugins
require("nano.pack").lazy_load()
-- (lazy) load builtin modules
require("nano.loader").lazy_load()
