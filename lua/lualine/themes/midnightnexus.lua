local colors = {
  bg        = '#0F111A',
  fg        = '#C0CAF5',
  grey      = '#3B4261',
  red       = '#F7768E',
  green     = '#9ECE6A',
  yellow    = '#E0AF68',
  blue      = '#7AA2F7',
  magenta   = '#BB9AF7',
  cyan      = '#7DCFFF',
  white     = '#C0CAF5',
}

local midnightnexus = {
  normal = {
    a = { bg = colors.blue, fg = colors.bg, gui = 'bold' },
    b = { bg = colors.grey, fg = colors.fg },
    c = { bg = colors.bg, fg = colors.fg },
  },
  insert = {
    a = { bg = colors.green, fg = colors.bg, gui = 'bold' },
    b = { bg = colors.grey, fg = colors.fg },
    c = { bg = colors.bg, fg = colors.fg },
  },
  visual = {
    a = { bg = colors.magenta, fg = colors.bg, gui = 'bold' },
    b = { bg = colors.grey, fg = colors.fg },
    c = { bg = colors.bg, fg = colors.fg },
  },
  replace = {
    a = { bg = colors.red, fg = colors.bg, gui = 'bold' },
    b = { bg = colors.grey, fg = colors.fg },
    c = { bg = colors.bg, fg = colors.fg },
  },
  command = {
    a = { bg = colors.yellow, fg = colors.bg, gui = 'bold' },
    b = { bg = colors.grey, fg = colors.fg },
    c = { bg = colors.bg, fg = colors.fg },
  },
  inactive = {
    a = { bg = colors.grey, fg = colors.fg, gui = 'bold' },
    b = { bg = colors.bg, fg = colors.grey },
    c = { bg = colors.bg, fg = colors.grey },
  },
}

return midnightnexus
