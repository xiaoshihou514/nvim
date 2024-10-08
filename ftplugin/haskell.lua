vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

require("plugins.guard")
ft("haskell"):fmt("ormolu"):lint("hlint")

-- local loaded
-- if loaded then
--     return
-- end
-- loaded = true

-- local dap = require("dap")
-- dap.adapters.haskell = {
--     type = "executable",
--     command = "haskell-debug-adapter",
--     args = { "--hackage-version=0.0.33.0" },
-- }
-- dap.configurations.haskell = {
--     {
--         type = "haskell",
--         request = "launch",
--         name = "Debug",
--         workspace = "${workspaceFolder}",
--         startup = "${file}",
--         stopOnEntry = true,
--         logFile = vim.fn.stdpath("data") .. "/haskell-dap.log",
--         logLevel = "WARNING",
--         ghciEnv = vim.empty_dict(),
--         ghciPrompt = "λ  ",
--         ghciInitialPrompt = "λ  ",
--         ghciCmd = "stack ghci --test --no-load --no-build --main-is TARGET --ghci-options -fprint-evld-with-show",
--     },
-- }

-- require("haskell-tools").lsp.start()
