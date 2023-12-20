return function(ensure, load_lsp, load_guard, load_dap, lsp_cb, guard_cb)
    local lspconfig, capabilities = unpack(load_lsp())
    local ft, lint = unpack(load_guard())
    local dap = load_dap()
    ensure({ "kotlin-language-server", "detekt", "ktlint", "kotlin-debug-adapter" })

    lspconfig.kotlin_language_server.setup({
        capabilities = capabilities,
        init_options = {}
    })

    ft("kotlin"):fmt({
        cmd = "ktlint",
        args = { "-F", "--stdin", "--log-level=error" },
        stdin = true,
    }):lint({
        cmd = "ktlint",
        args = { "--log-level=error" },
        fname = true,
        parse = lint.from_regex({
            source = "ktlint",
            regex = ":(%d+):(%d+): (.+) %((.-)%)",
            groups = { "lnum", "col", "message", "code" },
        }),
    }):append({
        cmd = "detekt",
        args = { "-i" },
        fname = true,
        parse = lint.from_regex({
            source = "detekt",
            regex = ":(%d+):(%d+):%s(.+)%s%[(.+)%]",
            groups = { "lnum", "col", "message", "code" },
        }),
    })


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
                local root = vim.fs.find("src", { path = vim.uv.cwd(), upward = true, stop = vim.env.HOME })[1] or ""
                local fname = vim.api.nvim_buf_get_name(0)
                return fname:gsub(root, ""):gsub("main/kotlin/", ""):gsub(".kt", "Kt"):gsub("/", "."):sub(2, -1)
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

    lsp_cb()
    guard_cb("kotlin")
end
