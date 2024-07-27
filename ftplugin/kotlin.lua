local loaded
if loaded then
    return
end
loaded = true

local dap = require("dap")

dap.adapters.kotlin = {
    type = "executable",
    command = "kotlin-debug-adapter",
    options = { auto_continue_if_many_stopped = false },
}

dap.configurations.kotlin = {
    {
        type = "kotlin",
        request = "launch",
        name = "This file",
        mainClass = function()
            local root = vim.fs.find(
                "src",
                { path = vim.uv.cwd(), upward = true, stop = vim.env.HOME }
            )[1] or ""
            local fname = vim.api.nvim_buf_get_name(0)
            return fname
                :gsub(root, "")
                :gsub("main/kotlin/", "")
                :gsub(".kt", "Kt")
                :gsub("/", ".")
                :sub(2, -1)
        end,
        projectRoot = vim.fn.getcwd,
        jsonLogFile = "",
        enableJsonLogging = false,
    },
    {
        type = "kotlin",
        request = "attach",
        name = "Attach to debugging session",
        port = 5005,
        args = {},
        projectRoot = vim.fn.getcwd,
        hostName = "localhost",
        timeout = 2000,
    },
}
