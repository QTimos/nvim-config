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
vim.keymap.set("x", "<leader>P", "\"_dP")

-- vim.keymap.set("n", "<leader>y", "\"+y")
-- vim.keymap.set("v", "<leader>y", "\"+y")
-- vim.keymap.set("n", "<leader>Y", "\"+Y")
-- vim.keymap.set("n", "<leader>d", "\"_d")
-- vim.keymap.set("v", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>y", function()
  local text = vim.fn.getreg('"')
  vim.fn.system(string.format("ssh user@host 'echo -n %q | xclip -selection clipboard'", text))
  print("Copied to host clipboard via SSH")
end, { desc = "Copy selection to host clipboard via SSH" })


vim.keymap.set("n", "<leader><A-l>", ":BufferLineCycleNext<CR>")
vim.keymap.set("n", "<leader><A-h>", ":BufferLineCyclePrev<CR>")
vim.keymap.set("n", "<leader><S-n>", ":BufferLinePickClose<CR>")

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
-- vim.keymap.set("n", "<leader>bc", ":!compile %:t<CR>")
vim.keymap.set("n", "<leader>bc", function()
    local current_file = vim.fn.expand("%:p:r")  -- Full path without extension
    local extra_files = vim.fn.input({
        prompt = "Additional files (space-separated, or Enter for none): ",
        completion = "file"
    })

    local compile_cmd
    if extra_files == "" then
        compile_cmd = "compile " .. current_file
    else
        compile_cmd = "compile " .. current_file .. " " .. extra_files
    end

    local buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded"
    })
    vim.fn.termopen(compile_cmd, {
        on_exit = function(_, exit_code)
            if exit_code == 0 then
                print("Compilation and execution successful!")
            else
                print("Exit code: " .. exit_code)
            end
        end
    })
    vim.cmd("startinsert")
    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
end)
vim.keymap.set("n", "<leader>r", ":!python %:t<CR>")

vim.keymap.set("n", "<Leader>n", ":next <CR>")
vim.keymap.set("n", "<Leader>p", ":prev <CR>")
