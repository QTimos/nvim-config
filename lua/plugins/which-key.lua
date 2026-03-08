return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		local wk = require("which-key")
		wk.setup({
			delay = 400,
			notify = false,
			icons = {
				rules = false,
			},
		})
		-- Register key group labels so which-key shows nice descriptions
		wk.add({
			{ "<leader>s", group = "LSP / Search" },
			{ "<leader>g", group = "Git / Format" },
			{ "<leader>d", group = "Debug / Delete" },
			{ "<leader>t", group = "Toggle" },
			{ "<leader>f", group = "Find / Files" },
			{ "<leader>b", group = "Build / Buffer" },
		})
	end,
}
