local loaded
if loaded then
    return
end
loaded = true

require("plugins.guard")
local lint = require("guard.lint")
ft("kotlin"):fmt("ktlint"):lint("ktlint"):append({
    cmd = "detekt-cli",
    args = { "-i" },
    fname = true,
    parse = lint.from_regex({
        source = "detekt",
        regex = ":(%d+):(%d+):%s(.+)%s%[(.+)%]",
        groups = { "lnum", "col", "message", "code" },
    }),
})
