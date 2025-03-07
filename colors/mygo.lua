---@diagnostic disable-next-line: inject-field
vim.g.colors_name = "mygo"
vim.o.background = "light"

-- palette
-- stylua: ignore start
local p = {
    bg       = "#FCE5D5", -- 57 75 93
    shade_1  = "#f2c0a4", -- 50 65 82
    shade_2  = "#df9c82", -- 42 54 71
    shade_3  = "#c07d6d", -- 35 44 60
    shade_4  = "#976660", -- 27 33 49
    shade_5  = "#6e5050", -- 20 23 38
    shade_6  = "#473b3c", -- 12 12 27
    fg       = "#232222", -- 4  1  15

    func     = "#ca7722",
    special  = "#EA9D76",
    error    = "#74494A",

    constant = "#cd132a",
    type     = "#a71f15",
    keyword  = "#122D54",
    info     = "#6A7EB2",
    string   = "#a3203f",
}
-- stylua: ignore end

local groups = require("personal.hlgroups")(p)

for group, hl in pairs(groups) do
    hl.force = true
    vim.api.nvim_set_hl(0, group, hl)
end
