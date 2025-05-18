return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
        { "mason-org/mason.nvim", version = "1.11.0" },
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap

		_G.lsp_diagnostics_config = {
			show_non_error_diagnostics = false
		}

		local function toggle_non_error_diagnostics()
			_G.lsp_diagnostics_config.show_non_error_diagnostics = not _G.lsp_diagnostics_config.show_non_error_diagnostics
			
			vim.notify("Non-error diagnostics " .. (_G.lsp_diagnostics_config.show_non_error_diagnostics and "enabled" or "disabled"))
			
			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(bufnr) then
					vim.diagnostic.reset(nil, bufnr)
					
					local ns = vim.diagnostic.get_namespaces()
					for ns_id, _ in pairs(ns) do
						local diagnostics = vim.diagnostic.get(bufnr, {namespace = ns_id})
						if diagnostics and #diagnostics > 0 then
							vim.diagnostic.set(ns_id, bufnr, diagnostics)
						end
					end
				end
			end
		end

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
				keymap.set("n", "<leader>tad", toggle_non_error_diagnostics, opts("Toggle non-error diagnostics"))
			end,
		})

		-- Client capabilities
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Filter function that keeps only error diagnostics unless show_non_error_diagnostics is true
		local function filter_diagnostics(diagnostics)
			if not diagnostics then return {} end
			
			if not _G.lsp_diagnostics_config.show_non_error_diagnostics then
				local filtered = {}
				for _, d in ipairs(diagnostics) do
					if d.severity == vim.diagnostic.severity.ERROR then
						table.insert(filtered, d)
					end
				end
				return filtered
			end
			
			return diagnostics
		end

		-- Override the diagnostic handler to apply our filtering
		local publish_diagnostics_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
		vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
			if result and result.diagnostics then
				result.diagnostics = filter_diagnostics(result.diagnostics)
			end
			return publish_diagnostics_handler(err, result, ctx, config)
		end

		-- Override vim.diagnostic.set to apply our filtering
		local original_diagnostic_set = vim.diagnostic.set
		vim.diagnostic.set = function(namespace, bufnr, diagnostics, opts)
			diagnostics = filter_diagnostics(diagnostics)
			return original_diagnostic_set(namespace, bufnr, diagnostics, opts)
		end

		-- Set up LSP servers
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
						Lua = {
							diagnostics = { globals = { 'vim' } },
							completion = { callSnippet = 'Replace' },
                        },
					},
				})
			end,

			-- Python LSP
			["pylsp"] = function()
				lspconfig.pylsp.setup({
					capabilities = capabilities,
					settings = {
						pylsp = {
							plugins = {
								pycodestyle = { enabled = false },
								pyflakes    = { enabled = false },
								pylint      = { enabled = false },
								mccabe      = { enabled = false },
								rope_completion = { enabled = false },
							},
						},
					},
				})
			end,

			-- C LSP
			["clangd"] = function()
				lspconfig.clangd.setup({
					capabilities = capabilities,
					settings = {
						clangd = {
                            fallbackFlags = { "-std=c11" },
                        },
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
