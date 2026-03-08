-- @diagnostic disable: missing-fields
return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"diff",
				"go",
				"html",
				"java",
				"javascript",
				"json",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"rust",
				"sql",
				"ssh_config",
				"tmux",
				"toml",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			},
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
