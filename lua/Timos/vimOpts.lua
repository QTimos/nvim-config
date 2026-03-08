vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Python provider: use Mason-managed venv if it exists, fall back to system python
local nvim_venv = vim.fn.expand("~/.venvs/nvim/bin/python")
if vim.fn.executable(nvim_venv) == 1 then
	vim.g.python3_host_prog = nvim_venv
else
	-- Fall back to system python3 (make sure pynvim is installed there)
	vim.g.python3_host_prog = vim.fn.exepath("python3") or "/usr/bin/python3"
end
vim.g.perl_host_prog = "/usr/bin/perl"

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- fold things
vim.opt.foldmethod = "manual"
vim.opt.foldlevel = 99

-- Columns / layout
vim.opt.colorcolumn = "120" -- 200 is very wide; 120 is more conventional
vim.opt.signcolumn = "yes" -- always show, prevents layout jumps
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8

-- Performance
vim.opt.updatetime = 100 -- faster CursorHold events (was 40, which is aggressive)
vim.opt.timeoutlen = 300

-- UI
vim.opt.cmdheight = 1 -- 2 wastes a line; 1 is fine with modern nvim
vim.opt.termguicolors = true
vim.opt.showmode = false -- lualine already shows the mode
vim.opt.pumheight = 10 -- limit completion popup height

-- Files / undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true -- persistent undo across sessions
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Indentation (4 spaces is a more common default; adjust per project via editorconfig)
vim.opt.expandtab = false
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smarttab = true

-- Whitespace display (off by default, toggled with <leader>w)
vim.opt.list = false
vim.opt.listchars = { space = "·", tab = ">>", trail = "·", extends = "❯", precedes = "❮", nbsp = "+" }

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true -- case-sensitive when uppercase used

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Mouse
vim.opt.mouse = "a"

-- Clipboard
vim.opt.clipboard = "unnamedplus" -- sync with system clipboard (remove if you prefer manual yank)

-- ─── LSP log truncation (prevents 100MB+ log files) ──────────────────────────
vim.lsp.set_log_level("WARN")
vim.defer_fn(function()
	local lsp_log = vim.lsp.get_log_path()
	local stat = vim.uv.fs_stat(lsp_log)
	if stat and stat.size > 10 * 1024 * 1024 then
		local f = io.open(lsp_log, "w")
		if f then
			f:close()
		end
		vim.notify("LSP log was over 10MB and has been truncated.", vim.log.levels.WARN)
	end
end, 2000)
