return {
    "xiyaowong/transparent.nvim",
    config = function()
        require("transparent").setup({
            -- table: default groups
            groups = {
                "Normal",
                "NormalNC",
                "Comment",
                "Constant",
                "Special",
                "Identifier",
                "Statement",
                "PreProc",
                "Type",
                "Underlined",
                "Todo",
                "String",
                "Function",
                "Conditional",
                "Repeat",
                "Operator",
                "Structure",
                "LineNr",
                "NonText",
                "SignColumn",
                "CursorLine",
                "CursorLineNr",
                "StatusLine",
                "StatusLineNC",
                "EndOfBuffer",
            },
            -- table: additional groups that should be cleared
            extra_groups = {
                "NeoTreeNormal",
            },
            on_clear = function() end,
        })
        vim.keymap.set("n", "<leader>tt", ":TransparentToggle<CR>")
    end,
}
