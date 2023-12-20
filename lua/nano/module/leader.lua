-- This plugin lets neovim wait longer when <Space> prefixed keybinds are pressed
-- Cause they can be really hard to press within 200ms(my timeoutlen)
-- For instance, imagine <Space>tv on a qwerty keyboard
local leader = " "
local leaderkeys = {}

local function await_input(key)
    local input = vim.fn.getcharstr()
    if string.byte(input) == 128 then
        -- backspace, remove one char
        if #key > 1 then
            key = key:sub(1, key:len() - 1)
        end
        -- esc, quit
    elseif string.byte(input) == 27 then
        return
    else
        key = key .. input
        local has_match = false
        for _, k in pairs(leaderkeys) do
            -- exact match
            if k.lhs == key then
                if type(k.rhs) == "function" then
                    return k.rhs()
                else
                    return vim.cmd(k.rhs:gsub("<Cmd>", ""):gsub("<CR>", ""))
                end
            end
            -- current combination is a prefix
            if k.lhs:sub(0, key:len()) == key then
                has_match = true
            end
        end
        -- if there's no key matching the current prefix just return
        if has_match then
            await_input(key)
        end
    end
end

local function leader_wait()
    local keys = vim.api.nvim_get_keymap("n")
    local bufkeys = vim.api.nvim_buf_get_keymap(0, "n")
    for _, k in pairs(vim.tbl_extend("keep", keys, bufkeys)) do
        if k.lhs ~= leader and k.lhs:sub(1, 1) == leader then
            table.insert(leaderkeys, { lhs = k.lhs, rhs = k.rhs or k.callback })
        end
    end
    await_input(leader)
end

bind("n", "<leader>", leader_wait)
