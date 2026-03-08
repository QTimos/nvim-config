require("Timos.vimOpts")
require("Timos.remap")
-- require("Timos.splash")

-- ─── Register missing filetypes ───────────────────────────────────────────────
vim.filetype.add({
	extension = {
		gowork = "gowork",
		gotmpl = "gotmpl",
		yml = "yaml",
	},
	filename = {
		[".env"] = "sh",
		[".env.local"] = "sh",
	},
})

-- Filetype-specific indentation overrides
-- Python requires spaces per PEP8
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python" },
	callback = function()
		vim.opt_local.expandtab = true
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
	end,
})
-- Web languages: strong 2-space-spaces community convention
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"html",
		"css",
		"json",
		"yaml",
		"vue",
		"svelte",
	},
	callback = function()
		vim.opt_local.expandtab = true
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.softtabstop = 2
	end,
})

-- Neovim's built-in ftplugins and some LSPs (e.g. lua_ls) reset indentation
-- on FileType. This autocmd runs after all that and restores the global defaults
-- for any filetype not explicitly handled above.
local space_filetypes = {
	python = true,
	javascript = true,
	typescript = true,
	javascriptreact = true,
	typescriptreact = true,
	html = true,
	css = true,
	json = true,
	yaml = true,
	vue = true,
	svelte = true,
}
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		local ft = vim.bo.filetype
		if not space_filetypes[ft] then
			vim.opt_local.expandtab = false
			vim.opt_local.tabstop = 4
			vim.opt_local.shiftwidth = 4
			vim.opt_local.softtabstop = 0
		end
	end,
})

-- ─── Trim trailing whitespace on save ────────────────────────────────────────
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		local save = vim.fn.winsaveview()
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.winrestview(save)
	end,
})

-- ─── Highlight yanked text briefly ───────────────────────────────────────────
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank({ higroup = "Visual", timeout = 150 })
	end,
})

-- ─── Return to last edit position ────────────────────────────────────────────
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local line_count = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})
