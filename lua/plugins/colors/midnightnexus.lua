return {
    {
        name = "midnightnexus",
        dir = vim.fn.stdpath("config") .. "/lua/Timos/",
        config = function()
            require('Timos.midnightnexusColorscheme').setup()
        end,
        lazy = false,
        priority = 1000,
    }
}
