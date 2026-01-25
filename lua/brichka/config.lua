local M = {}

local defaults = {
	cmd = {
		brichka = "brichka",
	},

	ui = {
		icons = {
			cluster = {
				running = "🟢",
				pending = "🔵",
				restarting = "♻️",
				resizing = "⚙️",
				terminating = "🔻",
				terminated = "🔴",
				error = "⚠️",
				unknown = "❔",
			},
		},
		render = {
			table = function(path)
				Snacks.terminal("vd --wrap " .. path, { win = { position = "bottom" } })
			end,
			text = function(value)
				Snacks.win({
					text = value,
					width = 0.6,
					height = 0.6,
				})
			end,
			error = function(message, cause)
				Snacks.win({
					text = message,
					width = 0.6,
					height = 0.6,
				})
			end,
		},
	},
	run = {
		start = false,
		init = false,
		spinner = true,
	},
	tools = {
		lualine = {},
	},
}

M.data = nil

function M.setup(opts)
	M.data = vim.tbl_deep_extend("force", defaults, opts)
end

return M
