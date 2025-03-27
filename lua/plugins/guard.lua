local loaded
if loaded then
    return
end
loaded = true

vim.cmd.packadd("guard-collection")

_G.ft = require("guard.filetype")

bind("n", "gq", "<cmd>Guard fmt<cr>")
