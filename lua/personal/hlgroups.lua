return function(p)
    return {
        -- UI Elements
        Normal = { bg = p.bg, fg = p.fg },
        Cursor = { bg = p.shade_4 },
        CursorLine = { bg = p.shade_1 },
        Search = { bg = p.shade_2 },
        IncSearch = { bg = p.func, fg = p.bg },
        CurSearch = { bg = p.func, fg = p.bg },
        LineNr = { fg = p.shade_2 },
        CursorLineNr = { fg = p.shade_3 },
        MatchParen = { bg = p.shade_2 },
        Pmenu = { bg = p.shade_1 },
        PmenuSel = { bg = p.keyword, fg = p.bg },
        PmenuKind = { bg = p.shade_1, fg = p.func },
        PmenuKindSel = { bg = p.keyword, fg = p.func },
        PmenuSbar = { bg = p.shade_1 },
        PmenuThumb = { bg = p.shade_2 },
        PmenuMatch = { fg = p.info },
        PmenuMatchSel = { bg = p.keyword, fg = p.bg, bold = true },
        TabLine = { bg = p.bg },
        TabLineSel = { bg = p.shade_2 },
        WinBar = { bg = p.bg, fg = p.shade_4, bold = true },
        WinBarNC = { bg = p.bg, fg = p.shade_3 },
        Visual = { bg = p.shade_2 },
        NormalFloat = { bg = p.bg },
        Float = { link = "Constant" },
        NvimFloat = { bg = p.shade_1 },
        FloatTitle = { fg = p.fg },
        FloatFooter = { fg = p.fg },
        FloatBorder = { fg = p.fg, bg = p.bg },
        FloatShadow = { fg = p.shade_1 },
        FloatThrough = { fg = p.shade_2 },
        ColorColumn = { bg = p.shade_2 },
        Directory = { fg = p.keyword },
        ErrorMsg = { fg = p.error },
        Error = { bg = p.error, fg = p.shade_2 },
        Folded = { bg = p.shade_1 },
        FoldColumn = { bg = p.bg, fg = p.keyword },
        SignColumn = { bg = p.bg },
        MoreMsg = { fg = p.string },
        Macro = { fg = p.error },
        EndOfBuffer = { fg = p.fg },
        NonText = { fg = p.info },
        SpellBad = { undercurl = true, sp = p.error },
        SpellCap = { undercurl = true, sp = p.keyword },
        SpellLocal = { undercurl = true, sp = p.info },
        SpellRare = { undercurl = true, sp = p.type },
        StatusLine = { bg = p.bg },
        Title = { fg = p.special, bold = true },
        WarningMsg = { fg = p.error },
        WildMenu = { bg = p.keyword },
        Todo = { bg = p.shade_2, fg = p.func },
        helpHyperTextJump = { fg = p.keyword, underline = true },
        helpHeader = { fg = p.special, bold = true },
        helpSectionDelim = { fg = p.shade_3 },
        Question = { fg = p.info },
        Conceal = { bg = p.shade_1 },
        Underlined = { fg = p.info, underline = true },
        DiffAdd = { bg = p.keyword, fg = p.shade_1, bold = true },
        DiffDelete = { bg = p.constant, fg = p.shade_1, bold = true },
        DiffText = { bg = p.error, fg = p.shade_1, bold = true },
        DiffChange = { bg = p.info, fg = p.shade_1, bold = true },
        Ignore = { fg = p.shade_1 },
        LspCodeLens = { fg = p.shade_5 },
        WinSeparator = { fg = p.shade_4 },
        QuickFixLine = { fg = p.info },
        LspInlayHint = { fg = p.shade_3 },

        -- Diagnostic
        DiagnosticOk = { fg = p.string },
        DiagnosticHint = { fg = p.keyword },
        DiagnosticInfo = { fg = p.func },
        DiagnosticWarn = { fg = p.special },
        DiagnosticError = { fg = p.error },
        DiagnosticUnderlineOk = { sp = p.string, undercurl = true },
        DiagnosticUnderlineHint = { sp = p.keyword, undercurl = true },
        DiagnosticUnderlineInfo = { sp = p.func, undercurl = true },
        DiagnosticUnderlineWarn = { sp = p.special, undercurl = true },
        DiagnosticUnderlineError = { sp = p.error, undercurl = true },
        DiagnosticFloatingOk = { fg = p.string },
        DiagnosticFloatingHint = { fg = p.keyword },
        DiagnosticFloatingInfo = { fg = p.func },
        DiagnosticFloatingWarn = { fg = p.special },
        DiagnosticFloatingError = { fg = p.error },

        -- My highlights
        DashboardHeader = { fg = p.func },
        DashboardShortcut = { fg = p.keyword, bold = true },
        DashboardFooter = { fg = p.string, italic = true },
        OnYank = { bg = p.shade_3 },
        NotifyDebug = { fg = p.keyword },
        NotifyError = { link = "DiagnosticError" },
        NotifyWarn = { link = "DiagnosticWarn" },
        NotifyInfo = { link = "Text" },
        NotifyTrace = { link = "Text" },
        NotifyOff = { fg = p.shade_2 },

        -- Plugins
        Indentline = { fg = p.shade_2 },
        IndentlineCurrent = { fg = p.shade_4 },

        -- syntax
        Keyword = { fg = p.keyword },
        Statement = { link = "Keyword" },
        Define = { link = "Keyword" },
        Include = { link = "Keyword" },
        Preproc = { link = "Keyword" },
        Identifier = { fg = p.fg },
        Function = { fg = p.func },
        Constant = { fg = p.constant },
        Type = { fg = p.type },
        String = { fg = p.string },
        Character = { fg = p.string },
        Operator = { fg = p.shade_5 },
        Special = { fg = p.special },
        Comment = { fg = p.shade_5 },
        Delimiter = { fg = p.shade_5 },
        ["@variable"] = { link = "Text" },

        -- Lang: Lua
        luaTable = { fg = p.shade_4 },
        luaFunction = { link = "Keyword" },
        ["@string.regexp.lua"] = { link = "String" },
        ["@lsp.typemod.property.declaration.lua"] = { link = "Comment" }, -- type annotation
        ["@constructor.lua"] = { link = "Text" },
        ["@module.builtin.lua"] = { link = "Text" },
        ["@character.special.vim"] = { link = "String" },
        ["@constant.builtin.lua"] = { link = "Constant" },

        -- Lang: Haskell
        hsImport = { link = "Keyword" },
        hsSpecialChar = { link = "String" },
        ConId = { link = "Type" },
        hsStructure = { link = "Keyword" },
        ["@function.haskell"] = { link = "Text" }, -- treesitter doesn't differentiate vars and functions well
        ["@function.call.haskell"] = { link = "Text" },
        ["@constructor.haskell"] = { link = "Type" },

        -- Lang: C
        cFormat = { link = "Keyword" },
        cSpecial = { link = "Keyword" },
        cDefine = { link = "Keyword" },
        ["@type.builtin.c"] = { link = "Type" },
        ["@constant.builtin.c"] = { link = "Keyword" },
        ["@string.escape.c"] = { link = "String" },
        ["cSpecialCharacter"] = { link = "String" },
        ["@type.builtin.cpp"] = { link = "Type" },
        ["@constant.c"] = { link = "Variable" },

        -- Lang: Kotlin
        ktStructure = { link = "Keyword" },
        ktModifier = { link = "Keyword" },
        ktArrow = { link = "Operator" },
        ktComplexInterpolation = { link = "Keyword" },
        ktComplexInterpolationBrace = { link = "Keyword" },
        ktSpecialChar = { link = "String" },
        ["@type.qualifier.kotlin"] = { link = "Keyword" },
        ["@constructor.kotlin"] = { link = "Text" },
        ["@punctuation.special.kotlin"] = { link = "Keyword" },
        ["@variable.builtin.kotlin"] = { link = "Keyword" },
        ["@attribute.kotlin"] = { link = "Keyword" },
        ["@function.builtin.kotlin"] = { link = "Keyword" },

        -- Lang: Fish
        fishOption = { link = "Text" },
        fishParameter = { link = "Text" },
        fishVariable = { link = "Special" },
        ["@function.builtin.fish"] = { link = "Function" },

        -- Lang: Vimdoc
        ["@variable.parameter.vimdoc"] = { link = "Keyword" },
        ["@text.reference.vimdoc"] = { link = "helpHyperTextJump" },

        -- Lang: Markdown
        ["@text.literal.block.markdown"] = { link = "Keyword" },
        ["@markup.raw.markdown_inline"] = { bold = true },
        ["@markup.raw.delimiter.markdown_inline"] = { bold = true },
        ["@markup.raw.block.markdown"] = { link = "Comment" },
        ["@markup.heading"] = { link = "Keyword" },
        ["@markup.italic.markdown_inline"] = { italic = true },
        markdownH1 = { link = "Keyword" },
        markdownH2 = { link = "Keyword" },
        markdownH3 = { link = "Keyword" },
        markdownH4 = { link = "Keyword" },
        markdownH5 = { link = "Keyword" },
        markdownH6 = { link = "Keyword" },

        -- Lang: Html
        ["@tag.html"] = { link = "Operator" },
        ["@tag.delimiter.html"] = { link = "Operator" },
        ["@tag.attribute.html"] = { link = "Text" },
        ["@text.title.html"] = { fg = p.fg, bold = true },
        ["@text.title.1.html"] = { fg = p.fg, bold = true },
        ["@text.title.2.html"] = { fg = p.fg, bold = true },

        -- Lang: Javascript
        ["@punctuation.bracket.javascript"] = { link = "Operator" },
        ["@punctuation.delimiter.javascript"] = { link = "Operator" },
        ["@text.literal.markdown_inline"] = { bold = true },
        ["@constant.builtin.java"] = { link = "Keyword" },

        -- Lang: Toml
        tomlTable = { fg = p.keyword },

        -- Lang: Dart
        ["@lsp.type.keyword.dart"] = { link = "Keyword" },
        ["@lsp.typemod.property.annotation.dart"] = { link = "Special" },
        ["@lsp.mod.interpolation"] = { link = "Special" },
        ["@type.qualifier.dart"] = { link = "Keyword" },

        -- Lang: Groovy
        ["@punctuation.special.groovy"] = { link = "String" },

        -- Lang: Java
        ["@variable.builtin.java"] = { link = "Keyword" },
        ["@attribute.java"] = { link = "Keyword" },
        ["@type.builtin.java"] = { link = "Type" },

        -- Lang: Makefile
        ["@string.special.symbol.make"] = { link = "Keyword" },

        -- Lang: Python
        ["@function.builtin.python"] = { link = "Function" },

        -- Lang: Latex
        ["@module.latex"] = { link = "Keyword" },
        ["@markup.heading.1.latex"] = { fg = p.fg, bold = true },
        ["@markup.heading.2.latex"] = { fg = p.fg, bold = true },
        ["@markup.heading.3.latex"] = { fg = p.fg, bold = true },
        ["@markup.heading.4.latex"] = { fg = p.fg, bold = true },

        -- Lang: Assembly
        ["@function.builtin.asm"] = { link = "Function" },
        ["@variable.builtin.asm"] = { link = "Variable" },

        -- Lang: Zig
        ["@constant.builtin.zig"] = { link = "Constant" },
        ["@lsp.type.namespace.zig"] = { fg = p.info },

        -- Lang: Rust
        ["@variable.builtin.rust"] = { link = "Function" },
        ["@lsp.type.enumMember.rust"] = { link = "Type" },

        -- Lang: Scala
        scalaOperator = { link = "Operator" },
        scalaUnimplemented = { link = "Function" },
        scalaNameDefinition = { link = "Variable" },
        scalaSpecial = { link = "Variable" },
        scalaEscapedChar = { link = "String" },
        ["@variable.builtin.scala"] = { link = "Keyword" },

        -- Lang: Tex
        texTypeStyle = { link = "Keyword" },

        -- Lang: Cpp
        ["@lsp.type.macro.cpp"] = { link = "Special" },

        -- Lang: CMake
        ["@function.builtin.cmake"] = { link = "Function" },
    }
end
