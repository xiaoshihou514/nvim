-- load time tracking module
local perf = require("nano.perf")
-- Fire up dashboard ASAP to minimize visual delay
vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = function()
        require("nano.builtin.keys")
        local dashboard = require("nano.module.dashboard")
        if vim.fn.argc() == 0 then
            dashboard(perf.cputime())
        end
    end
})
-- ensure all specified plugins are installed
require("nano.pack").ensure()
-- (lazy) load plugins
require("nano.pack").lazy_load()
-- (lazy) load builtin modules
require("nano.pack").lazy_load_modules()
