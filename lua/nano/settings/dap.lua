local dap, dapui = require("dap"), require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "String", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
bind("n", "<F5>", require("dap").continue)
bind("n", "<F9>", require("dap").toggle_breakpoint)
bind("n", "S-<F9>", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end)
bind("n", "<F10>", require("dap").step_over)
bind("n", "<F11>", require("dap").step_into)
bind("n", "S-<F11>", require("dap").step_out)
bind("n", "S-<F5>", "<cmd>DapTerminate<cr>")
-- bind("n", "<Leader>dl", function() require("dap").run_last() end)
-- bind({ "n", "v" }, "<Leader>dh", function()
--     require("dap.ui.widgets").hover()
-- end)
-- bind({ "n", "v" }, "<Leader>dp", function()
--     require("dap.ui.widgets").preview()
-- end)
-- bind("n", "<Leader>df", function()
--     local widgets = require("dap.ui.widgets")
--     widgets.centered_float(widgets.frames)
-- end)
-- bind("n", "<Leader>ds", function()
--     local widgets = require("dap.ui.widgets")
--     widgets.centered_float(widgets.scopes)
-- end)

require("dapui").setup({
    mappings = { expand = { "<CR>", "<2-LeftMouse>" } },
    expand_lines = false,
    layouts = {
        {
            elements = {
                { id = "scopes",  size = 0.5 },
                { id = "stacks",  size = 0.25 },
                { id = "watches", size = 0.25 },
            },
            size = 0.33,
            position = "right",
        },
        {
            elements = { { id = "repl", size = 1 } },
            size = 0.27,
            position = "bottom",
        },
    },
    controls = { enabled = true },
    floating = {
        max_height = 0.9,
        max_width = 0.5,
        border = "single",
        mappings = { close = { "q", "<Esc>" } },
    },
    windows = { indent = 1 },
})
