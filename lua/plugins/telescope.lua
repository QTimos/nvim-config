return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim", "BurntSushi/ripgrep", "sharkdp/fd" },
		config = function()
			local builtin = require("telescope.builtin")
			local actions = require("telescope.actions")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>pf", builtin.live_grep, {})
			vim.keymap.set("n", "<leader><C-O>", ":Telescope oldfiles<CR>", {})
			vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "Telescope git files" })
			vim.keymap.set("n", "<leader>ps", function()
				builtin.grep_string({ search = vim.fn.input("Grep > ") })
			end)
			vim.keymap.set("n", "<leader>AZ", function()
					builtin.find_files({
						attach_mappings = function(prompt_bufnr, _)
							vim.defer_fn(function ()
								actions.select_vertical(prompt_bufnr)
							end,20)
							return true
						end,
					})
				end, { desc = "Telescope find files and open in vsplit" })
			vim.keymap.set("n", "<leader>ZA", function()
					builtin.find_files({
						attach_mappings = function(prompt_bufnr, _)
							vim.defer_fn(function ()
								actions.select_horizontal(prompt_bufnr)
							end,20)
							return true
						end,
					})
				end, { desc = "Telescope find files and open in vsplit" })
		end
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),

						-- specific_opts = {
						--   [kind] = {
						--     make_indexed = function(items) -> indexed_items, width,
						--     make_displayer = function(widths) -> displayer
						--     make_display = function(displayer) -> function(e)
						--     make_ordinal = function(e) -> string
						--   },
						--   codeactions = false,
						-- }
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
