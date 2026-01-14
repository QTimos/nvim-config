vim.g.mapleader = " "
-- vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.python3_host_prog = "/home/hdyani/.local/bin/pynvim-python"
vim.g.perl_host_prog = "/usr/bin/perl"


vim.cmd("set number")
vim.cmd("set relativenumber")
vim.cmd("set colorcolumn=200")
vim.cmd("set updatetime=40")
vim.cmd("set cmdheight=2")
vim.o.wrap = false

vim.o.swapfile = false
vim.o.backup = false

vim.opt.expandtab = true
vim.cmd("set autoindent")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set softtabstop=4")

vim.cmd("setlocal list")

vim.cmd("set scrolloff=10")
vim.o.signcolumn = "yes"

vim.cmd("set smarttab")
vim.cmd("set mouse=a")

vim.cmd("set termguicolors")

vim.o.hlsearch = false
vim.o.incsearch = true
