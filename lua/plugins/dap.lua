return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
	},
	config = function ()
		local dap = require("dap")

		vim.keymap.set("n", "<leader>tb", dap.toggle_breakpoint, {})
		vim.keymap.set("n", "<leader>c", dap.continue, {})
	end
}
