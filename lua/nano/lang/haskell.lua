return function(_, load_guard, load_dap, _, guard_cb)
    local ft, lint = unpack(load_guard())
    local dap = load_dap()
    local haskell = ft("haskell")
    vim.cmd.packadd("haskell-tools.nvim")

    haskell:fmt({
        cmd = "ormolu",
        args = { "--color", "never", "--stdin-input-file" },
        stdin = true,
        fname = true,
    }):lint({
        cmd = "hlint",
        args = { "--json", "--no-exit-code" },
        fname = true,
        parse = function(result, bufnr)
            local diags = {}
            local severities = {
                suggestion = lint.severities.info,
                warning = lint.severities.warning,
                error = lint.severities.error,
            }
            result = result ~= "" and vim.json.decode(result) or {}
            for _, d in ipairs(result) do
                table.insert(
                    diags,
                    lint.diag_fmt(
                        bufnr,
                        d.startLine > 0 and d.startLine - 1 or 0,
                        d.startLine > 0 and d.startColumn - 1 or 0,
                        d.hint .. (d.to ~= vim.NIL and (": " .. d.to) or ""),
                        severities[d.severity:lower()],
                        "hlint"
                    )
                )
            end
            return diags
        end,
    })


    dap.adapters.haskell = {
        type = "executable",
        command = "haskell-debug-adapter",
        args = { "--hackage-version=0.0.33.0" },
    }
    dap.configurations.haskell = {
        {
            type = "haskell",
            request = "launch",
            name = "Debug",
            workspace = "${workspaceFolder}",
            startup = "${file}",
            stopOnEntry = true,
            logFile = vim.fn.stdpath("data") .. "/haskell-dap.log",
            logLevel = "WARNING",
            ghciEnv = vim.empty_dict(),
            ghciPrompt = "λ  ",
            ghciInitialPrompt = "λ  ",
            ghciCmd = "stack ghci --test --no-load --no-build --main-is TARGET --ghci-options -fprint-evld-with-show",
        },
    }

    guard_cb("haskell")
end
