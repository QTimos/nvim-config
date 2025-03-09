return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local function opts(desc)
					return { desc = desc, buffer = ev.buf, silent = true }
				end

				keymap.set("n", "<leader>K", vim.lsp.buf.hover, opts("Show documentation"))
				keymap.set("n", "<leader>sr", "<cmd>Telescope lsp_references<cr>", opts("Show LSP references"))
				keymap.set("n", "<leader>sdd", vim.lsp.buf.declaration, opts("Go to declaration"))
				keymap.set("n", "<leader>sd", "<cmd>Telescope lsp_definitions<cr>", opts("Show LSP definitions"))
				keymap.set(
					"n",
					"<leader>si",
					"<cmd>Telescope lsp_implementations<cr>",
					opts("Show LSP implementations")
				)
				keymap.set(
					"n",
					"<leader>st",
					"<cmd>Telescope lsp_type_definitions<cr>",
					opts("Show LSP type definitions")
				)
				keymap.set({ "n", "v" }, "<leader>sa", vim.lsp.buf.code_action, opts("Show available code actions"))
			end,
		})

		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Disable all diagnostics (warnings, errors etc.)
		-- local no_diagnostics = {
		-- 	['textDocument/publishDiagnostics'] = function(_, _, _, _, _)
		-- 		return
		-- 	end,
		-- }

		-- Specify handlers
		mason_lspconfig.setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,


			-- Grammarly LSP
			["grammarly"] = function()
				lspconfig.grammarly.setup({
					capabilities = capabilities,
					settings = {
						grammarly = {},
					},
				})
			end,

			-- Lua LSP
			["lua_ls"] = function()
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {},
					},
				})
			end,

			-- Python LSP
			["pylsp"] = function()
				lspconfig.pylsp.setup({
					capabilities = capabilities,
					settings = {
						pylsp = {
							plugins = {},
						},
					},
				})
			end,

			-- C LSP
			["clangd"] = function()
				lspconfig.clangd.setup({
					capabilities = capabilities,
					settings = {
						clangd = {},
					},
				})
			end,

			-- Bash LSP
			["bashls"] = function()
				lspconfig.bashls.setup({
					capabilities = capabilities,
					settings = {
						bashls = {},
					},
				})
			end,

			-- ast_grep LSP
			["ast_grep"] = function()
				lspconfig.ast_grep.setup({
					capabilities = capabilities,
					settings = {
						ast_grep = {},
					},
				})
			end,

			-- harper_ls LSP
			["harper_ls"] = function()
				lspconfig.harper_ls.setup({
					capabilities = capabilities,
					settings = {
						harper_ls = {},
					},
				})
			end,

			-- CSS LSP
			["cssls"] = function()
				lspconfig.cssls.setup({
					capabilities = capabilities,
					settings = {
						cssls = {},
					},
				})
			end,

			-- HTML LSP
			["html"] = function()
				lspconfig.html.setup({
					capabilities = capabilities,
					settings = {
						html = {},
					},
				})
			end,

			-- ts_ls LSP
			["ts_ls"] = function()
				lspconfig.ts_ls.setup({
					capabilities = capabilities,
					settings = {
						ts_ls = {},
					},
				})
			end,

			-- JSON LSP
			["jsonls"] = function()
				lspconfig.jsonls.setup({
					capabilities = capabilities,
					settings = {
						jsonls = {},
					},
				})
			end,

			-- VimScript LSP
			["vimls"] = function()
				lspconfig.vimls.setup({
					capabilities = capabilities,
					settings = {
						vimls = {},
					},
				})
			end,
		})
	end,
}
