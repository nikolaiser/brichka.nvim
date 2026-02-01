local M = {}

local configuration = require("brichka.config").data

local function format_cluster(cluster)
	local cluster_icons = configuration.ui.icons.cluster

	local cluster_state_icon = cluster_icons[string.lower(cluster.state)] or cluster_icons.unknown

	return cluster_state_icon .. cluster.name
end

local function choose_cluster(cluster, idx)
	if idx == nil then
		return
	end

	local cwd = vim.fn.getcwd()
	local config_path = cwd .. "/.brichka"
	vim.fn.mkdir(config_path, "p")
	local cluster_config_path = config_path .. "/cluster.json"
	local json = vim.fn.json_encode({ id = cluster.id, name = cluster.name })
	local file = io.open(cluster_config_path, "w")
	if file then
		file:write(json)
		file:close()
	end
end

local function select_cluster(results_raw)
	vim.schedule(function()
		if result_raw.stderr ~= "" then
			vim.notify(result_raw.stderr, "ERROR")
		else
			local clusters = vim.json.decode(results_raw.stdout)
			vim.ui.select(clusters, { prompt = "Select cluster", format_item = format_cluster }, choose_cluster)
		end
	end)
end

function M.select()
	local brichka_cmd = configuration.cmd.brichka

	vim.system({ brichka_cmd, "cluster", "list" }, { text = true }, select_cluster)
end

return M
