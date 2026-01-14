return {
    "ojroques/nvim-osc52",
    lazy = false,
    config = function()
        vim.opt.termguicolors = true
        local osc52 = require("osc52")
        osc52.setup({
            max_length = 0,
            silent = false,
            trim = false,
            enable = true,
            tmux = true,
            yank_registers = { "+", "*" },
        })
        vim.keymap.set("v", "<leader>y", function()
            osc52.copy_visual() print("Copied via OSC52")
        end, { desc = "Copy selection via OSC52" })
        vim.api.nvim_create_autocmd("TextYankPost",
            { callback = function()
                if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
                    osc52.copy_register("")
                end
            end, })
    end, }
