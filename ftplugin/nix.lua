vim.opt_local.shiftwidth = 2

local ft = require("guard.filetype")

ft("nix"):fmt({
    cmd = "nixpkgs-fmt",
    stdin = true,
})
