vim.opt_local.wrap = true
vim.opt_local.spell = true
vim.api.nvim_create_user_command("TexCompile", function()
	local file = vim.api.nvim_buf_get_name(0)
	local cwd = string.match(file, "(.*/).*")
	local cmd = "cd '%s' && pdflatex -shell-escape -interaction=nonstopmode '%s'"
	local handle = io.popen(string.format(cmd, cwd, file))
	if not handle then
		print("Command execution failed")
		return
	end
	local output = handle:read("*a")
	local _, _, code = handle:close()
	if code ~= 0 then
		local lines = vim.split(output, "\n")
		local start, finish = 1, #lines
		local flag = "(see the transcript file for additional information)"
		for i, l in ipairs(lines) do
			if l:find("!") and start == 1 then
				start = i
			end
			if l:find(flag) then
				finish = i - 1
				break
			end
		end
		print(table.concat(lines, "\n", start, finish):gsub("\t", "  "))
	end
end, {})
