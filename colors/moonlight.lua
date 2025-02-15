---@diagnostic disable-next-line: inject-field
vim.g.colors_name = "moonlight"
vim.o.background = "dark"

-- palette
-- stylua: ignore start
local p = {
    -- design: low saturation, use lightness to create contrast
    --                             H   S L
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
    magenta = "#c59eb4", -- OKHSL: 332,45,70
    purple  = "#876aa8", -- OKHSL: 305,44,51
    blue    = "#51849e", -- OKHSL: 231,44,52
    cyan    = "#42868d", -- OKHSL: 205,54,51 saturation high for better contrast with blue
    green   = "#738b58", -- OKHSL: 129,45,54
}
-- stylua: ignore end

local groups = require("personal.hlgroups")(p)

for group, hl in pairs(groups) do
    hl.force = true
    vim.api.nvim_set_hl(0, group, hl)
end
