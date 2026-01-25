local M = {}

local did_setup = false

function M.setup(opts)
	if did_setup then
		return
	end
	did_setup = true
	require("brichka.config").setup(opts)
end

return M
