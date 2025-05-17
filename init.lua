require("Timos")
require("config.lazy")
require('floating_term').setup({
  width = 0.85,
  height = 0.8,
  toggle_keymap = '<C-<>',
  
  border = 'rounded',
  winblend = 10,
  border_color = "FloatingTermBorder",
  float_hl = "FloatingTermBackground",
  title = " Terminal ",
  title_pos = "center",
  
  padding = {
    top = 1,
    right = 2,
    bottom = 1,
    left = 2
  }
})
