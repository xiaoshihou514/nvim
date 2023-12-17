vim.cmd("hi clear")
vim.g.colors_name = "moonlight"
vim.o.background = "dark"

local p = {
    -- design: low saturation, use lightness to create contrast
    bg      = "#1F2224", -- OKHSL: 237,6,15
    shade_1 = "#323639", -- OKHSL: 237,6,23
    shade_2 = "#44494c", -- OKHSL: 237,6,31
    shade_3 = "#575c61", -- OKHSL: 237,6,39
    shade_4 = "#6a7175", -- OKHSL: 237,6,47
    shade_5 = "#7e858a", -- OKHSL: 237,6,55
    shade_6 = "#939a9f", -- OKHSL: 237,6,63
    fg      = "#a8aeb4", -- OKHSL: 237,6,71
    -- brighter warning colors (high lightness)
    yellow  = "#c9bb7f", -- OKHSL: 97,49,76
    orange  = "#d5a37b", -- OKHSL: 60,48,71
    red     = "#d89e98", -- OKHSL: 25,44,71
    -- complementary colors, not-so-high lightness
    magenta = "#cb98c3", -- OKHSL: 332,45,70
    purple  = "#876aa8", -- OKHSL: 305,44,51
    blue    = "#51849e", -- OKHSL: 231,44,52
    cyan    = "#42868d", -- OKHSL: 205,54,51 saturation high for better contrast with blue
    green   = "#738b58", -- OKHSL: 129,45,54
}

local groups = {
    -- UI Elements
    Normal = { bg = p.bg, fg = p.fg },
    Cursor = { bg = p.shade_4 },
    CursorLine = { bg = p.shade_1 },
    Search = { reverse = true },
    IncSearch = { bg = p.shade_3 },
    LineNr = { fg = p.shade_2 },
    CursorLineNr = { fg = p.shade_3 },
    MatchParen = { bg = p.shade_2 },
    Pmenu = { bg = p.bg },
    PmenuSel = { bg = p.blue, fg = p.bg },
    PmenuKind = { fg = p.yellow },
    PmenuKindSel = { bg = p.blue, fg = p.yellow },
    PmenuSbar = { bg = p.bg },
    PmenuThumb = { bg = p.shade_1 },
    TabLine = { bg = p.bg },
    TabLineSel = { bg = p.shade_2 },
    WinBar = { bg = p.bg },
    WinBarNC = { bg = p.bg },
    Visual = { bg = p.shade_2 },
    NormalFloat = { bg = p.shade_1 },
    FloatTitle = { fg = p.fg },
    FloatFooter = { fg = p.fg },
    FloatBorder = { fg = p.shade_3 },
    FloatShadow = { fg = p.shade_1 },
    FloatThrough = { fg = p.shade_2 },
    ColorColumn = { bg = p.shade_2 },
    Directory = { fg = p.blue },
    ErrorMsg = { bg = p.red, fg = p.shade_2 },
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

    -- Lang: Lua
    luaTable = { fg = p.shade_4 },
    luaFunction = { link = "Keyword" },
    ["@lsp.typemod.property.declaration.lua"] = { link = "Comment" }, -- type annotation

    -- Lang: Haskell
    hsImport = { link = "Keyword" },
    hsSpecialChar = { link = "String" },
    ConId = { link = "Type" },
    hsStructure = { link = "Keyword" },

    -- Lang: C
    cFormat = { link = "Keyword" },
    cSpecial = { link = "Keyword" },

    -- Lang: Kotlin
    ktStructure = { link = "Keyword" },
    ktModifier = { link = "Keyword" },
    ktArrow = { link = "Operator" },
    ktComplexInterpolation = { link = "Keyword" },
    ktComplexInterpolationBrace = { link = "Keyword" },

    -- Lang: Fish
    fishOption = { link = "Text" },
    fishParameter = { link = "Text" },
    fishVariable = { link = "Special" },

    -- Lang: Vimdoc
    ["@parameter.vimdoc"] = { link = "Keyword" },
    ["@text.reference.vimdoc"] = { link = "helpHyperTextJump" },

    -- My highlights
    Indentline = { fg = p.shade_2 },
    DashboardHeader = { fg = p.yellow },
    DashboardShortcut = { fg = p.blue, bold = true },
    DashboardFooter = { fg = p.green, italic = true },

    -- Plugins
    MiniHipatternsFixme = { bg = p.shade_2, fg = p.red },
    MiniHipatternsHack = { bg = p.shade_2, fg = p.orange },
    MiniHipatternsNote = { bg = p.shade_2, fg = p.blue },

    TreesitterContext = { bg = p.shade_1 },

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
    DapUIWatchesEmpty = { fg = p.shade_4 },
}

for group, hl in pairs(groups) do
    vim.api.nvim_set_hl(0, group, hl)
end
