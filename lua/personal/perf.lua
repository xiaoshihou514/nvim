-- https://github.com/folke/lazy.nvim/blob/96584866b9c5e998cbae300594d0ccfd0c464627/lua/lazy/stats.lua#L33-L69
local ffi = require("ffi")
if not vim.g.loaded_perf then
    ffi.cdef([[
            typedef long time_t;
            typedef int clockid_t;
            typedef struct timespec {
              time_t   tv_sec;        /* seconds */
              long     tv_nsec;       /* nanoseconds */
            } nanotime;
            int clock_gettime(clockid_t clk_id, struct timespec *tp);
        ]])
    ---@diagnostic disable-next-line: inject-field
    vim.g.loaded_perf = true
end

local M = {}

local pnano = assert(ffi.new("nanotime[?]", 1))
local CLOCK_PROCESS_CPUTIME_ID = jit.os == "OSX" and 12 or 2

function M.cputime()
    ffi.C.clock_gettime(CLOCK_PROCESS_CPUTIME_ID, pnano)
    return tonumber(pnano[0].tv_sec) * 1e3 + tonumber(pnano[0].tv_nsec) / 1e6
end

function M.record(f)
    local start = M.cputime()
    f()
    return string.format("%.2f", M.cputime() - start)
end

return M
