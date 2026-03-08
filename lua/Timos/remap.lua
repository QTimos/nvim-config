-- ─── Whitespace toggle ────────────────────────────────────────────────────────
local whitespace_enabled = false
vim.keymap.set("n", "<leader>w", function()
	whitespace_enabled = not whitespace_enabled
	vim.opt.list = whitespace_enabled
	if whitespace_enabled then
		vim.cmd("highlight Whitespace guifg=#6b6e85")
	end
end, { desc = "Toggle whitespace display" })

-- ─── File navigation ──────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>cd", ":cd %:p:h<CR>", { desc = "cd to current file dir" })

-- ─── Window management ────────────────────────────────────────────────────────
vim.keymap.set("n", "<A-o>", ":only<CR>", { desc = "Close all other windows" })

-- ─── Plugin managers ──────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>la", ":Lazy<CR>", { desc = "Open Lazy" })
vim.keymap.set("n", "<leader>ma", ":Mason<CR>", { desc = "Open Mason" })

-- ─── Move lines in visual mode ────────────────────────────────────────────────
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ─── Better J / search centering ──────────────────────────────────────────────
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines, keep cursor position" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- ─── Paste without clobbering register ───────────────────────────────────────
vim.keymap.set("x", "<leader>P", '"_dP', { desc = "Paste without losing register" })

-- ─── Yank / delete to system clipboard ───────────────────────────────────────
-- (vim.opt.clipboard = "unnamedplus" in vimOpts handles this globally,
--  but keeping explicit binds as fallback when clipboard option is off)
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete to black hole" })

-- ─── BufferLine navigation ────────────────────────────────────────────────────
vim.keymap.set("n", "<A-l>", ":BufferLineCycleNext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<A-h>", ":BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
vim.keymap.set("n", "<A-w>", ":BufferLinePickClose<CR>", { desc = "Pick buffer to close" })

-- ─── Disable accidental middle-click paste ────────────────────────────────────
for _, mode in ipairs({ "n", "i" }) do
	for _, click in ipairs({ "<MiddleMouse>", "<2-MiddleMouse>", "<3-MiddleMouse>", "<4-MiddleMouse>" }) do
		vim.keymap.set(mode, click, "<Nop>")
	end
end

-- ─── Search/replace word under cursor ────────────────────────────────────────
vim.keymap.set(
	"n",
	"<leader>s",
	":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
	{ desc = "Replace word (global)" }
)
vim.keymap.set(
	"n",
	"<leader>S",
	":s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
	{ desc = "Replace word (line)" }
)

-- ─── Tmux sessionizer ─────────────────────────────────────────────────────────
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Open tmux sessionizer" })
vim.keymap.set(
	"n",
	"<leader>od",
	":execute '!tmux split-window -v -c ' . shellescape(expand('%:p:h'))<CR>",
	{ desc = "Open tmux split in file dir" }
)

-- ─── Compile & run (floating terminal) ───────────────────────────────────────
local function open_float_term(cmd)
	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
	})
	vim.fn.termopen(cmd, {
		on_exit = function(_, code)
			vim.notify("Exit code: " .. code, code == 0 and vim.log.levels.INFO or vim.log.levels.WARN)
		end,
	})
	vim.cmd("startinsert")
	vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
	return buf, win
end

vim.keymap.set("n", "<leader>bc", function()
	local current_file = vim.fn.expand("%:p:r")
	local extra = vim.fn.input({ prompt = "Additional files (space-separated): ", completion = "file" })
	local cmd = "compile " .. current_file .. (extra ~= "" and (" " .. extra) or "")
	open_float_term(cmd)
end, { desc = "Compile current file" })

vim.keymap.set("n", "<leader>bt", function()
	local file = vim.fn.expand("%:t")
	vim.cmd("cd " .. vim.fn.escape(vim.fn.expand("%:p:h"), " "))
	vim.cmd("silent !browse " .. vim.fn.escape(file, " "))
end, { desc = "Open file in browser" })

vim.keymap.set("n", "<leader>r", function()
	open_float_term("python " .. vim.fn.expand("%:t"))
end, { desc = "Run Python file" })

-- ─── Arglist navigation ───────────────────────────────────────────────────────
vim.keymap.set("n", "<Leader>n", ":next<CR>", { desc = "Next in arglist" })
vim.keymap.set("n", "<Leader>p", ":prev<CR>", { desc = "Prev in arglist" })

-- ─── Man page for word under cursor ──────────────────────────────────────────
vim.keymap.set("n", "<leader>man", ":!man <cword><CR>", { desc = "Man page for word" })

-- ─── Quick-escape terminal mode ───────────────────────────────────────────────
vim.keymap.set("t", "<Leader><Esc>", "<C-\\><C-n> :q! <CR>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<A-BS>", "zf")
vim.keymap.set("n", "<BS>", "za")
vim.keymap.set("v", "<BS>", "za")
vim.keymap.set("n", "<C-BS>", "zR")
vim.keymap.set("n", "<Leader><BS>", "zE")
