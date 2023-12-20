local hop = require("nano.module.squirrel.hop")

bind({ "n", "x" }, "gaa", hop.hop_linewise)
bind({ "n", "x" }, "ga", hop.hop)
bind({ "n", "x" }, "gee", function()
    hop.hop_linewise({
        head = false,
        tail = true,
    })
end)
bind({ "n", "x" }, "ge", function()
    hop.hop({
        head = false,
        tail = true,
    })
end)
