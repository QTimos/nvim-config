return {
    "mbbill/undotree",
    config = function()
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        local undo_dir = vim.fn.expand('~/.nvim/undodir')
        if vim.fn.isdirectory(undo_dir) == 0 then
            vim.fn.mkdir(undo_dir, 'p')
        end

        vim.o.undodir = undo_dir
        vim.o.undofile = true

        vim.g.undotree_WindowLayout = 4
        vim.g.undotree_HighlightChangedWithSign = 1
    end,
}
