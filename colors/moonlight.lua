---@diagnostic disable-next-line: inject-field
vim.g.colors_name = "moonlight"
vim.o.background = "dark"

-- palette
local p = {
    -- design: low saturation, use lightness to create contrast
    --                             H   S L
    bg = "#1F2224", -- OKHSL: 237,6,15
    shade_1 = "#323639", -- OKHSL: 237,6,23
    shade_2 = "#44494c", -- OKHSL: 237,6,31
    shade_3 = "#575c61", -- OKHSL: 237,6,39
    shade_4 = "#6a7175", -- OKHSL: 237,6,47
    shade_5 = "#7e858a", -- OKHSL: 237,6,55
    shade_6 = "#939a9f", -- OKHSL: 237,6,63
    fg = "#a8aeb4", -- OKHSL: 237,6,71

    -- brighter warning colors (high lightness)
    yellow = "#c9bb7f", -- OKHSL: 97,49,76
    orange = "#d5a37b", -- OKHSL: 60,48,71
    red = "#d89e98", -- OKHSL: 25,44,71

    -- complementary colors, not-so-high lightness
    magenta = "#c59eb4", -- OKHSL: 332,45,70
    purple = "#876aa8", -- OKHSL: 305,44,51
    blue = "#51849e", -- OKHSL: 231,44,52
    cyan = "#42868d", -- OKHSL: 205,54,51 saturation high for better contrast with blue
    green = "#738b58", -- OKHSL: 129,45,54
}

local groups = {
    -- UI Elements
    Normal = { fg = p.fg },
    Cursor = { bg = p.shade_4 },
    CursorLine = { bg = p.shade_1 },
    Search = { bg = p.shade_2 },
    IncSearch = { bg = p.yellow, fg = p.bg },
    CurSearch = { bg = p.yellow, fg = p.bg },
    LineNr = { fg = p.shade_2 },
    CursorLineNr = { fg = p.shade_3 },
    MatchParen = { bg = p.shade_2 },
    Pmenu = { bg = p.shade_1 },
    PmenuSel = { bg = p.blue, fg = p.bg },
    PmenuKind = { bg = p.shade_1, fg = p.yellow },
    PmenuKindSel = { bg = p.blue, fg = p.yellow },
    PmenuSbar = { bg = p.shade_1 },
    PmenuThumb = { bg = p.shade_2 },
    TabLine = { bg = p.bg },
    TabLineSel = { bg = p.shade_2 },
    WinBar = { bg = p.bg, fg = p.shade_4, bold = true },
    WinBarNC = { bg = p.bg, fg = p.shade_3 },
    Visual = { bg = p.shade_2 },
    NormalFloat = { bg = p.bg },
    Float = { bg = p.shade_1 },
    NvimFloat = { bg = p.shade_1 },
    FloatTitle = { fg = p.fg },
    FloatFooter = { fg = p.fg },
    FloatBorder = { fg = p.fg, bg = p.bg },
    FloatShadow = { fg = p.shade_1 },
    FloatThrough = { fg = p.shade_2 },
    ColorColumn = { bg = p.shade_2 },
    Directory = { fg = p.blue },
    ErrorMsg = { fg = p.red },
    Error = { bg = p.red, fg = p.shade_2 },
    Folded = { bg = p.shade_1 },
    FoldColumn = { bg = p.bg, fg = p.blue },
    SignColumn = { bg = p.bg },
    MoreMsg = { fg = p.green },
    Macro = { fg = p.red },
    EndOfBuffer = { fg = p.fg },
    NonText = { fg = p.cyan },
    SpellBad = { undercurl = true, sp = p.red },
    SpellCap = { undercurl = true, sp = p.blue },
    SpellLocal = { undercurl = true, sp = p.cyan },
    SpellRare = { undercurl = true, sp = p.purple },
    StatusLine = { bg = p.bg },
    Title = { fg = p.orange, bold = true },
    WarningMsg = { fg = p.red },
    WildMenu = { bg = p.blue },
    Todo = { bg = p.shade_2, fg = p.yellow },
    helpHyperTextJump = { fg = p.blue, underline = true },
    helpHeader = { fg = p.orange, bold = true },
    helpSectionDelim = { fg = p.shade_3 },
    Question = { fg = p.cyan },
    Conceal = { bg = p.shade_1 },
    Underlined = { fg = p.cyan, underline = true },
    DiffAdd = { bg = p.blue, fg = p.shade_1, bold = true },
    DiffDelete = { bg = p.magenta, fg = p.shade_1, bold = true },
    DiffText = { bg = p.red, fg = p.shade_1, bold = true },
    DiffChange = { bg = p.cyan, fg = p.shade_1, bold = true },
    Ignore = { fg = p.shade_1 },
    LspCodeLens = { fg = p.shade_5 },
    WinSeparator = { fg = p.shade_4 },
    QuickFixLine = { fg = p.cyan },
    LspInlayHint = { fg = p.shade_3 },

    -- Diagnostic
    DiagnosticOk = { fg = p.green },
    DiagnosticHint = { fg = p.blue },
    DiagnosticInfo = { fg = p.yellow },
    DiagnosticWarn = { fg = p.orange },
    DiagnosticError = { fg = p.red },
    DiagnosticUnderlineOk = { sp = p.green, undercurl = true },
    DiagnosticUnderlineHint = { sp = p.blue, undercurl = true },
    DiagnosticUnderlineInfo = { sp = p.yellow, undercurl = true },
    DiagnosticUnderlineWarn = { sp = p.orange, undercurl = true },
    DiagnosticUnderlineError = { sp = p.red, undercurl = true },
    DiagnosticFloatingOk = { fg = p.green },
    DiagnosticFloatingHint = { fg = p.blue },
    DiagnosticFloatingInfo = { fg = p.yellow },
    DiagnosticFloatingWarn = { fg = p.orange },
    DiagnosticFloatingError = { fg = p.red },

    -- My highlights
    DashboardHeader = { fg = p.yellow },
    DashboardShortcut = { fg = p.blue, bold = true },
    DashboardFooter = { fg = p.green, italic = true },
    OnYank = { bg = p.shade_3 },
    NotifyDebug = { fg = p.blue },
    NotifyError = { link = "DiagnosticError" },
    NotifyWarn = { link = "DiagnosticWarn" },
    NotifyInfo = { link = "Text" },
    NotifyTrace = { link = "Text" },
    NotifyOff = { fg = p.shade_2 },
    -- ShovelPrompt = { fg = p.red },
    -- ShovelListPrompt = { fg = p.fg },
    -- ShovelSelected = { link = "Visual" },

    -- Plugins
    DapUIType = { link = "Type" },
    DapUISource = { fg = p.purple },
    DapUIStepInto = { fg = p.blue },
    DapUIStepOut = { fg = p.yellow },
    DapUIStepOver = { fg = p.blue },
    DapUIStepBack = { fg = p.yellow },
    DapUIStop = { fg = p.red },
    DapUIRestart = { fg = p.yellow },
    DapUIPlayPause = { fg = p.green },
    DapUIScope = { fg = p.cyan },
    DapUICurrentFrameName = { fg = p.green },
    DapUIStoppedThread = { fg = p.blue },
    DapUIDecoration = { fg = p.blue },
    CmpItemAbbr = { link = "Normal" },
    CmpItemAbbrDeprecated = { strikethrough = true },
    CmpItemAbbrMatch = { link = "Keyword" },
    CmpItemAbbrMatchFuzzy = { link = "Keyword" },
    CmpItemKind = { link = "Comment" },
    Indentline = { fg = p.shade_2 },
    IndentlineCurrent = { fg = p.shade_4 },

    -- syntax
    -- blue keywords, purple types, magenta consts, green strings
    -- yellow functions
    Keyword = { fg = p.blue },
    Statement = { link = "Keyword" },
    Define = { link = "Keyword" },
    Include = { link = "Keyword" },
    Preproc = { link = "Keyword" },
    Identifier = { fg = p.fg },
    Function = { fg = p.yellow },
    Constant = { fg = p.magenta },
    Type = { fg = p.purple },
    String = { fg = p.green },
    Character = { fg = p.green },
    Operator = { fg = p.shade_5 },
    Special = { fg = p.orange },
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
    tomlTable = { fg = p.blue },

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
    ["@lsp.type.namespace.zig"] = { fg = p.cyan },

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
}

for group, hl in pairs(groups) do
    vim.api.nvim_set_hl(0, group, hl)
end
