local dap = require("dap")

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "String", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })

bind("n", "<F5>", dap.continue)
bind("n", "<F9>", dap.toggle_breakpoint)
bind("n", "S-<F9>", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end)
bind("n", "<F10>", dap.step_over)
bind("n", "<F11>", dap.step_into)
bind("n", "S-<F11>", dap.step_out)
bind("n", "S-<F5>", "<cmd>DapTerminate<cr>")
