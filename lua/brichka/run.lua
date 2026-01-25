local M = {}

local configuration = require("brichka.config").data
local spinner = require("brichka.spinner")

local function display_result(result)
	if configuration.run.spinner then
		spinner.hide()
	end
	if result.type == "table" then
		configuration.ui.render.table(result.path)
	elseif result.type == "text" then
		configuration.ui.render.text(result.value)
	elseif result.type == "error" then
		configuration.ui.render.error(result.message, result.cause)
	end
end

local function process_result(result_raw)
	local result = vim.json.decode(result_raw.stdout)
	vim.schedule(function()
		display_result(result)
	end)
end

function M.run(command, language)
	if configuration.run.spinner then
		spinner.show()
	end
	local cmd = { configuration.cmd.brichka, "run", "--language", language, "-" }
	if configuration.run.init then
		table.insert(cmd, "--init")
	end
	if configuration.run.start then
		table.insert(cmd, "--start")
	end

	vim.system(cmd, { text = true, stdin = command }, process_result)
end

return M
