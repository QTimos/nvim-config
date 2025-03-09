return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			pip = {
				upgrade_pip = true,
			},
		})

		mason_lspconfig.setup({
			automatic_installation = {},
			ensure_installed = {
				"asm_lsp",
				"bashls",
				"clangd",
				"ast_grep",
				"harper_ls",
				"cssls",
				"html",
				"lua_ls",
				"ts_ls",
				"jsonls",
				"pylsp",
				"vimls",
				"grammarly"
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier",
				"isort",
			},
		})
	end,
}
