local M = {}
local api = vim.api
local group = api.nvim_create_augroup("NanoPack", {})

local loaded_lsp, loaded_guard, loaded_dap = false, false, false
local default_cap
local guard = {}
local dap

local function load_lsp()
	if not loaded_lsp then
		vim.cmd.packadd("epo.nvim")
		vim.cmd.packadd("nvim-lspconfig")

		require("lspconfig.ui.windows").default_options.border = "single"
		require("lspconfig.ui.windows").default_options.winhighlight = "FloatBorder:Normal"
		default_cap =
			vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), require("epo").register_cap())
		loaded_lsp = true
	end

	return {
		require("lspconfig"),
		default_cap,
	}
end

local function load_guard()
	if not loaded_guard then
		vim.cmd.packadd("guard.nvim")
		guard.filetype = require("guard.filetype")
		guard.lint = require("guard.lint")
		guard.events = require("guard.events")
		guard.format = require("guard.format")
		bind("n", "gq", "<cmd>GuardFmt<cr>")
		loaded_guard = true
	end
	return {
		guard.filetype,
		guard.lint,
	}
end

local function load_dap()
	if not loaded_dap then
		vim.cmd.packadd("nvim-dap")
		vim.cmd.packadd("nvim-dap-ui")
		dap = require("dap")
		---@diagnostic disable-next-line: different-requires
		require("nano.config.dap")
		require("nano.config.dap-ui")
		loaded_dap = true
	end
	return dap
end

local function lsp_cb()
	api.nvim_command("LspStart")
end

local function guard_cb(ft)
	local conf = guard.filetype[ft]
	guard.format.attach_to_buf(0)
	guard.events.create_lspattach_autocmd(true)
	local lint_events = { "BufWritePost", "BufEnter" }

	if conf.formatter then
		guard.events.watch_ft(ft)
		lint_events[1] = "User GuardFmt"
	end
	if not conf.linter then
		return
	end

	for i, _ in ipairs(conf.linter) do
		if conf.linter[i].stdin then
			table.insert(lint_events, "TextChanged")
			table.insert(lint_events, "InsertLeave")
		end
		guard.lint.register_lint(ft, lint_events)
		api.nvim_exec_autocmds("Filetype", { pattern = ft, group = "Guard" })
	end
end

local function load(package)
	vim.cmd.packadd(package)
	pcall(require, "nano.config." .. package)
end

function M.lazy_load_lang_modules()
	for ft, setup in pairs(require("nano.lang")) do
		api.nvim_create_autocmd("Filetype", {
			group = group,
			pattern = ft,
			once = true,
			callback = vim.schedule_wrap(function()
				setup(load, load_lsp, load_guard, load_dap, lsp_cb, guard_cb)
			end),
		})
	end
end

function M.lazy_load_modules()
	api.nvim_create_autocmd("UIEnter", {
		group = group,
		once = true,
		callback = function()
			require("nano.builtin.diagnostic")
			require("nano.builtin.autocmd")

			require("nano.module.ui")
			require("nano.module.fold")
			require("nano.module.indentline")
			require("nano.module.smoothscroll")
			require("nano.module.statusline")
			require("nano.module.term")
			require("nano.module.comment")
			require("nano.module.surround")
		end,
	})
end

return M
