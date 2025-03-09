return {
	"mbbill/undotree",
	config = function()
		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		vim.fn.mkdir(target_path, "p", 0700)

		vim.o.undodir = target_path
		vim.o.undofile = true

		vim.g.undotree_WindowLayout = 4

		vim.g.undotree_HighlightChangedWithSign = 1
	end,
}
