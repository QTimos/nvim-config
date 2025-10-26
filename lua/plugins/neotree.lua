return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		local tree = require("neo-tree")
		tree.setup({
			filesystem = {
				hijack_netrw_behavior = "disabled",
				follow_current_file = {
					enabled = true,
				},
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
			},

			window = {
				mappings = {
					["<leader>ZA"] = "open_split",
					["<leader>AZ"] = "open_vsplit",
					["<leader><C-P>"] = {
						"toggle_preview",
						config = {
							use_float = false,
							use_image_nvim = true,
						},
					},
					["<leader><CR>"] = function(state)
						local node = state.tree:get_node()
						if node and node.type == "file" then
							vim.cmd("edit " .. node.path)
							vim.cmd("Neotree close")
						else
							print("No file selected.")
						end
					end,
				},
			},

			event_handlers = {
				{
					event = "vim_buffer_enter",
					handler = function() end,
				},
			},

			use_libuv_file_watcher = true,
			open_on_setup = false,
			enable_git_status = true,
			popup_border_style = "rounded",
		})
		vim.keymap.set("n", "<leader>ft", ":Neotree filesystem reveal left<CR>", {})
		vim.keymap.set("n", "<leader>fr", ":cd %:p:h | pwd | Neotree filesystem reveal left<CR>", {})
	end,
}
