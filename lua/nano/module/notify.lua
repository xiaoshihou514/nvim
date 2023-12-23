local api = vim.api

local highlights = {
    [0] = "NotifyTrace",
    [1] = "NotifyDebug",
    [2] = "NotifyInfo",
    [3] = "NotifyWarn",
    [4] = "NotifyError",
    [5] = "NotifyOff",
}

-- vim.notify = function(msg, level, _)
--     -- TODO
-- end
