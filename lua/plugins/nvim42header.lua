return {
    dir = vim.fn.stdpath("config") .. "/lua/Timos",
    name = "nvim42header",
    config = function()
        local header = dofile(vim.fn.stdpath("config") .. "/lua/Timos/nvim42header.lua")
        
        header.setup({
            user = "hdyani",
            mail = "marvin@42.fr"
        })
        
        vim.keymap.set("n", "<leader><F2>", ":Stdheader<CR>", { desc = "Insert 42 header" })
    end
}
