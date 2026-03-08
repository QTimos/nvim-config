-- @diagnostic disable: missing-fields
return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		-- nvim-treesitter v1.0+ API (configs module was removed)
		vim.treesitter.language.register("markdown", "mdx")

		require("nvim-treesitter").setup({
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
		})

		-- Highlight and indent are enabled by default in v1.0,
		-- but can be explicitly set via vim options:
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		vim.opt.foldenable = false -- don't fold on open
	end,
}
