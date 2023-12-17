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
