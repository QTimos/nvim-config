vim.g.python3_host_prog = "~/.venv/bin/python"

vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
        if vim.fn.argc() == 0 then
            -- If in a directory, open netrw (Explore)
            vim.cmd("Explore")
            -- Close neotree if it's automatically opened
            vim.cmd("Neotree close")
        end
    end,
})


vim.cmd("set number")
vim.cmd("set relativenumber")
vim.cmd("set autoindent")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set softtabstop=4")
vim.cmd("set smarttab")
vim.cmd("set mouse=a")
