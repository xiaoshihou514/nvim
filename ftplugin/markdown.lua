vim.opt_local.wrap = true
vim.opt_local.spell = true

local ft = require("guard.filetype")

ft("markdown"):fmt({
    cmd = "prettier",
    args = { "--stdin-filepath" },
    fname = true,
    stdin = true,
})
