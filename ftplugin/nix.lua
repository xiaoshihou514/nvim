vim.opt_local.shiftwidth = 2

require("plugins.guard")

ft("nix"):fmt({
    cmd = "nixpkgs-fmt",
    stdin = true,
})
