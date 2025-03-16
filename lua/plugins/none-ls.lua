return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local none_ls = require("null-ls")
		none_ls.setup({
			sources = {
				none_ls.builtins.completion.spell,
				none_ls.builtins.diagnostics.textlint,
				none_ls.builtins.diagnostics.semgrep,

				none_ls.builtins.formatting.clang_format,
				require("none-ls.diagnostics.cpplint"),

				none_ls.builtins.formatting.stylua,
				-- none_ls.builtins.diagnostics.selene,

				none_ls.builtins.formatting.prettier,
				none_ls.builtins.formatting.prettierd,
				none_ls.builtins.diagnostics.stylelint,
				require("none-ls.diagnostics.eslint_d"),

				none_ls.builtins.formatting.black,
				none_ls.builtins.formatting.isort,
			},
		})
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
