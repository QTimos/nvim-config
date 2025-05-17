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

		local show_non_error_diagnostics = false
		local function toggle_non_error_diagnostics()
			show_non_error_diagnostics = not show_non_error_diagnostics
			vim.notify("Non-error diagnostics " .. (show_non_error_diagnostics and "enabled" or "disabled"))
			vim.diagnostic.reset()
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

		local capabilities = cmp_nvim_lsp.default_capabilities()

		local custom_diagnostics_handler = function(_, result, ctx, config)
			if not show_non_error_diagnostics then
				local filtered_diagnostics = {}
				for _, diagnostic in ipairs(result.diagnostics or {}) do
					if diagnostic.severity == vim.diagnostic.severity.ERROR then
						table.insert(filtered_diagnostics, diagnostic)
					end
				end
				result.diagnostics = filtered_diagnostics
			end
			vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
		end

		mason_lspconfig.setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
                    handlers = {
                        ['textDocument/publishDiagnostics'] = custom_diagnostics_handler,
                    },
				})
			end,

			-- Grammarly LSP
			["grammarly"] = function()
				lspconfig.grammarly.setup({
					capabilities = capabilities,
                    handlers = {
                        ['textDocument/publishDiagnostics'] = custom_diagnostics_handler,
                    },
					settings = {
						grammarly = {},
					},
				})
			end,

			-- Lua LSP
			["lua_ls"] = function()
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
                    handlers = {
                        ['textDocument/publishDiagnostics'] = custom_diagnostics_handler,
                    },
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
                    handlers = {
                        ['textDocument/publishDiagnostics'] = custom_diagnostics_handler,
                    },
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
                    handlers = {
                        ['textDocument/publishDiagnostics'] = custom_diagnostics_handler,
                    },
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
                    handlers = {
                        ['textDocument/publishDiagnostics'] = custom_diagnostics_handler,
                    },
					settings = {
						bashls = {},
					},
				})
			end,

			-- ast_grep LSP
			["ast_grep"] = function()
				lspconfig.ast_grep.setup({
					capabilities = capabilities,
                    handlers = {
                        ['textDocument/publishDiagnostics'] = custom_diagnostics_handler,
                    },
					settings = {
						ast_grep = {},
					},
				})
			end,

			-- harper_ls LSP
			["harper_ls"] = function()
				lspconfig.harper_ls.setup({
					capabilities = capabilities,
                    handlers = {
                        ['textDocument/publishDiagnostics'] = custom_diagnostics_handler,
                    },
					settings = {
						harper_ls = {},
					},
				})
			end,

			-- CSS LSP
			["cssls"] = function()
				lspconfig.cssls.setup({
					capabilities = capabilities,
                    handlers = {
                        ['textDocument/publishDiagnostics'] = custom_diagnostics_handler,
                    },
					settings = {
						cssls = {},
					},
				})
			end,

			-- HTML LSP
			["html"] = function()
				lspconfig.html.setup({
					capabilities = capabilities,
                    handlers = {
                        ['textDocument/publishDiagnostics'] = custom_diagnostics_handler,
                    },
					settings = {
						html = {},
					},
				})
			end,

			-- ts_ls LSP
			["ts_ls"] = function()
				lspconfig.ts_ls.setup({
					capabilities = capabilities,
                    handlers = {
                        ['textDocument/publishDiagnostics'] = custom_diagnostics_handler,
                    },
					settings = {
						ts_ls = {},
					},
				})
			end,

			-- JSON LSP
			["jsonls"] = function()
				lspconfig.jsonls.setup({
					capabilities = capabilities,
                    handlers = {
                        ['textDocument/publishDiagnostics'] = custom_diagnostics_handler,
                    },
					settings = {
						jsonls = {},
					},
				})
			end,

			-- VimScript LSP
			["vimls"] = function()
				lspconfig.vimls.setup({
					capabilities = capabilities,
                    handlers = {
                        ['textDocument/publishDiagnostics'] = custom_diagnostics_handler,
                    },
					settings = {
						vimls = {},
					},
				})
			end,
		})
	end,
}
