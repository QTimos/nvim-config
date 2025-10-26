return {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("nordic").setup({
            on_palette = function(palette) end,
            after_palette = function(palette) end,
            on_highlight = function(highlights, palette) end,
            bold_keywords = false,
            italic_comments = true,
            transparent = {
                bg = false,
                float = false,
            },
            bright_border = false,
            reduced_blue = true,
            swap_backgrounds = false,
            cursorline = {
                bold = false,
                bold_number = true,
                theme = "dark",
                blend = 0.85,
            },
            noice = {
                style = "classic",
            },
            telescope = {
                style = "flat",
            },
            leap = {
                dim_backdrop = false,
            },
            ts_context = {
                dark_background = true,
            },
        })
        -- require("nordic").load()
    end,
}
