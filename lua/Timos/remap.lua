vim.keymap.set("n", "<leader>w", function()
    whitespace_enabled = not whitespace_enabled
    if whitespace_enabled then
        vim.opt.list = true
        vim.cmd("highlight Whitespace guifg=#6b6e85")
        vim.opt.listchars = "space:.,tab:>>,trail:·,extends:❯,precedes:❮,nbsp:+"
    else
        vim.opt.list = false
    end
end)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<leader>cd", ":cd %:p:h<CR>")
vim.keymap.set("n", "<A-o>", ":only<CR>")

vim.keymap.set("n", "<leader>la", ":Lazy<CR>")
vim.keymap.set("n", "<leader>ma", ":Mason<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("n", "<MiddleMouse>", "<Nop>")
vim.keymap.set("i", "<MiddleMouse>", "<Nop>")
vim.keymap.set("n", "<2-MiddleMouse>", "<Nop>")
vim.keymap.set("i", "<2-MiddleMouse>", "<Nop>")
vim.keymap.set("n", "<3-MiddleMouse>", "<Nop>")
vim.keymap.set("i", "<3-MiddleMouse>", "<Nop>")
vim.keymap.set("n", "<4-MiddleMouse>", "<Nop>")
vim.keymap.set("i", "<4-MiddleMouse>", "<Nop>")

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
vim.keymap.set("n", "<leader>S", ":s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>od", ":execute '!tmux split-window -v -c ' . shellescape(expand('%:p:h'))<CR>")

vim.keymap.set("n", "<leader>bt", function()
    local file_dir = vim.fn.expand("%:p:h")
    local file_name = vim.fn.expand("%:t")
    vim.cmd("cd " .. vim.fn.escape(file_dir, " "))
    vim.cmd("silent !browse " .. vim.fn.escape(file_name, " "))
end, { noremap = true })
vim.keymap.set("n", "<leader>bc", ":!compile %:t<CR>")
vim.keymap.set("n", "<leader>r", ":!python %:t<CR>")

