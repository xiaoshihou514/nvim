local lint = require("guard.lint")
local ft = require("guard.filetype")

ft("fish"):fmt({
    cmd = 'fish_indent',
    stdin = true,
})

ft("rust"):fmt({
    cmd = "rustfmt",
    args = { "--edition", "2021", "--emit", "stdout" },
    stdin = true,
})

ft("html,markdown,json,yaml"):fmt({
    cmd = "prettier",
    args = { "--stdin-filepath" },
    fname = true,
    stdin = true,
})

ft("tex,plaintex,bib"):fmt({
    cmd = "latexindent",
    args = { "-g", "/dev/null" },
    stdin = true,
})

ft("c,cpp"):fmt({
    cmd = "clang-format",
    stdin = true,
})

ft("python"):fmt({
    cmd = "black",
    args = { "--quiet", "-" },
    stdin = true,
}):lint({
    cmd = "flake8",
    args = { "--format", "default", "-", "--stdin-display-name" },
    stdin = true,
    fname = true,
    parse = lint.from_regex({
        source = "flake8",
        regex = ":(%d+):(%d+):%s(%a)(%w+) (.+)",
        severities = {
            E = lint.severities.error,
            W = lint.severities.warning,
            C = lint.severities.warning,
            F = lint.severities.info,
        },
    }),
})

ft("haskell"):fmt({
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

ft("kotlin")
    :fmt({
        cmd = "ktlint",
        args = { "-F", "--stdin", "--log-level=error" },
        stdin = true,
    })
    :lint({
        cmd = "ktlint",
        args = { "--log-level=error" },
        fname = true,
        parse = lint.from_regex({
            source = "ktlint",
            regex = ":(%d+):(%d+): (.+) %((.-)%)",
            groups = { "lnum", "col", "message", "code" },
        }),
    })
    :append({
        cmd = "detekt-cli",
        args = { "-i" },
        fname = true,
        parse = lint.from_regex({
            source = "detekt",
            regex = ":(%d+):(%d+):%s(.+)%s%[(.+)%]",
            groups = { "lnum", "col", "message", "code" },
        }),
    })

ft("dart"):fmt({
    cmd = "dart",
    args = { "format" },
    stdin = true
})

ft("nix"):fmt({
    cmd = "nixpkgs-fmt",
    stdin = true,
})

ft("java"):fmt({
    fn = function(bufnr, range)
        vim.lsp.buf.format({ bufnr = bufnr, range = range, async = true })
    end,
})

require("guard").setup({
    fmt_on_save = true,
    lsp_as_default_formatter = true,
})

bind("n", "gq", "<cmd>GuardFmt<cr>")
