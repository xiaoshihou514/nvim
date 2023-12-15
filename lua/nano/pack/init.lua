local ui = require("nano.pack.ui")

local M = {
    -- all pkgs
    pkgs = {},
    -- pkgs to be installed
    to_install = {},
    -- spec
    plugins = require("nano.pack.plugins")
}

local pack_path = vim.fn.stdpath("data") .. "/site/pack/nano/opt/"
local git_prefix = "https://github.com/"
local function ensure(plugin)
    local full_name = plugin[1]
    local name = vim.split(full_name, "/")[2]
    local path = pack_path .. name
    local pkg = {
        full_name = name,
        path = path,
        installed = vim.uv.fs_stat(path),
        url = git_prefix .. full_name,
    }
    table.insert(M.pkgs, pkg)
    if not pkg.installed then
        table.insert(M.to_install, pkg)
    end
    if plugin.dependencies then
        vim.tbl_map(ensure, plugin.dependencies)
    end
end


function M.ensure()
    vim.tbl_map(ensure, M.plugins)
    if not #M.to_install == 0 then
        ui.update_state(M)
        ui.show()
        ui.sync_and_close()
    end
end

function M.create_load_events()
    -- TODO
end

function M.show_ui()
    vim.tbl_map(ensure, M.plugins)
    ui.update_state(M)
    ui.show()
end

api.nvim_create_user_command("NanoPack", M.show_ui, {})

return M
