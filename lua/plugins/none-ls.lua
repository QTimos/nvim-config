return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local none_ls = require("null-ls")

		none_ls.setup({
			-- Format on save (optional: remove if you prefer manual formatting)
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					local ft = vim.bo[bufnr].filetype
					if ft == "c" or ft == "cpp" then
						return
					end
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ bufnr = bufnr, async = false })
						end,
					})
				end
			end,
			sources = {
				-- Diagnostics
				none_ls.builtins.diagnostics.semgrep,
				require("none-ls.diagnostics.eslint_d"),
				none_ls.builtins.diagnostics.stylelint,

				-- Formatting
				none_ls.builtins.formatting.clang_format,
				none_ls.builtins.formatting.stylua,
				none_ls.builtins.formatting.prettierd, -- prettierd is faster than prettier; use one not both
				none_ls.builtins.formatting.black,
				none_ls.builtins.formatting.isort,

				-- Completion
				none_ls.builtins.completion.spell,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>gf", function()
			vim.lsp.buf.format({ async = true })
		end, { desc = "Format buffer / selection" })
	end,
}
