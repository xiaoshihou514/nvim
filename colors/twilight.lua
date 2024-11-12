-- TODO

---@diagnostic disable-next-line: inject-field
vim.g.colors_name = "twilight"
vim.o.background = "light"

-- palette
local p = {
    -- moonlight, light inverted, with a few tweaks
    -- design: low saturation, use lightness to create contrast
    --                             H   S L
    bg = "#eff1f2", -- OKHSL: 237,6,95
    shade_1 = "#d7dbdd", -- OKHSL: 237,6,87
    shade_2 = "#bfc5c8", -- OKHSL: 237,6,79
    shade_3 = "#a9afb4", -- OKHSL: 237,6,71
    shade_4 = "#939a9f", -- OKHSL: 237,6,63
    shade_5 = "#7e858a", -- OKHSL: 237,6,55
    shade_6 = "#6a7175", -- OKHSL: 237,6,47
    fg = "#575c61", -- OKHSL: 237,6,39

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

local groups = require("personal.hlgroups")(p)

for group, hl in pairs(groups) do
    hl.force = true
    vim.api.nvim_set_hl(0, group, hl)
end
