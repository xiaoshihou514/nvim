-- enable lua byte code cacheing
vim.loader.enable()

---@diagnostic disable: inject-field
-- disable builtin plugins
vim.g.loaded_fzf = 1
vim.g.loaded_gzip = 1
vim.g.editorconfig = false
vim.g.loaded_matchit = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_tutor_mode_plugin = 1

-- https://github.com/folke/lazy.nvim/blob/96584866b9c5e998cbae300594d0ccfd0c464627/lua/lazy/stats.lua#L33-L69
local function cputime()
    local ffi = require("ffi")
    pcall(function()
        ffi.cdef([[
            typedef long time_t;
            typedef int clockid_t;
            typedef struct timespec {
              time_t   tv_sec;        /* seconds */
              long     tv_nsec;       /* nanoseconds */
            } nanotime;
            int clock_gettime(clockid_t clk_id, struct timespec *tp);
        ]])
    end)
    local pnano = assert(ffi.new("nanotime[?]", 1))
    local CLOCK_PROCESS_CPUTIME_ID = jit.os == "OSX" and 12 or 2
    ffi.C.clock_gettime(CLOCK_PROCESS_CPUTIME_ID, pnano)
    return tonumber(pnano[0].tv_sec) * 1e3 + tonumber(pnano[0].tv_nsec) / 1e6
end

-- seamless dashboard, also records starting time accurately!
if vim.v.vim_did_enter ~= 1 then
    vim.api.nvim_create_autocmd("UIEnter", {
        callback = function()
            if vim.fn.argc() == 0 then
                require("nano.editor.dashboard").new(cputime())
            end
        end
    })
end

require("nano")

vim.cmd.color("moonlight")
