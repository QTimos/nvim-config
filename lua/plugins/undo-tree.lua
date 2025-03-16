return {
	"mbbill/undotree",
	config = function()
		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

		vim.o.undodir = "/home/timos/.nvim/undodir"
		vim.o.undofile = true

		vim.g.undotree_WindowLayout = 4
		vim.g.undotree_HighlightChangedWithSign = 1
	end,
}
