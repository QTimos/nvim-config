return {
    {
        name = "midnightnexus",
        dir = "~/.config/nvim/lua/Timos/",
        config = function()
            require('Timos.midnightnexus-colorscheme').setup()
        end,
        lazy = false,
        priority = 1000,
    }
}
