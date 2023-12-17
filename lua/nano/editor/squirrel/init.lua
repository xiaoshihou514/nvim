bind({ "n", "x" }, "gaa", require("xsh.squirrel.hop").hop_linewise)
bind({ "n", "x" }, "ga", require("xsh.squirrel.hop").hop)
bind({ "n", "x" }, "gee", function()
    require("xsh.squirrel.hop").hop_linewise({
        head = false,
        tail = true,
    })
end)
bind({ "n", "x" }, "ge", function()
    require("xsh.squirrel.hop").hop({
        head = false,
        tail = true,
    })
end)
