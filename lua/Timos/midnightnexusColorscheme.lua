local M = {}
M.colors = {
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

function M.setup()
    -- Set terminal colors
    vim.g.colors_name = "midnightnexus"

    vim.g.terminal_color_0  = M.colors.bg
    vim.g.terminal_color_1  = M.colors.red
    vim.g.terminal_color_2  = M.colors.green
    vim.g.terminal_color_3  = M.colors.yellow
    vim.g.terminal_color_4  = M.colors.blue
    vim.g.terminal_color_5  = M.colors.magenta
    vim.g.terminal_color_6  = M.colors.cyan
    vim.g.terminal_color_7  = M.colors.fg
    vim.g.terminal_color_8  = M.colors.grey
    vim.g.terminal_color_9  = '#F7768E'
    vim.g.terminal_color_10 = '#9ECE6A'
    vim.g.terminal_color_11 = '#E0AF68'
    vim.g.terminal_color_12 = '#7AA2F7'
    vim.g.terminal_color_13 = '#BB9AF7'
    vim.g.terminal_color_14 = '#7DCFFF'
    vim.g.terminal_color_15 = '#C0CAF5'

    -- Basic highlighting groups
    local highlight = vim.api.nvim_set_hl
    local colors = M.colors

    -- Base
    highlight(0, 'Normal', { fg = colors.fg, bg = colors.bg })
    highlight(0, 'Comment', { fg = colors.grey, italic = true })

    -- Constants
    highlight(0, 'Constant', { fg = colors.cyan })
    highlight(0, 'String', { fg = colors.green })
    highlight(0, 'Character', { fg = colors.green })
    highlight(0, 'Number', { fg = colors.yellow })
    highlight(0, 'Boolean', { fg = colors.yellow })
    highlight(0, 'Float', { fg = colors.yellow })

    -- Identifiers
    highlight(0, 'Identifier', { fg = colors.cyan })
    highlight(0, 'Function', { fg = colors.blue })

    -- Statements
    highlight(0, 'Statement', { fg = colors.magenta, bold = true })
    highlight(0, 'Conditional', { fg = colors.magenta, bold = true })
    highlight(0, 'Repeat', { fg = colors.magenta, bold = true })
    highlight(0, 'Label', { fg = colors.magenta })
    highlight(0, 'Operator', { fg = colors.magenta })
    highlight(0, 'Keyword', { fg = colors.magenta, bold = true })
    highlight(0, 'Exception', { fg = colors.red })

    -- Preprocessor
    highlight(0, 'PreProc', { fg = colors.yellow })
    highlight(0, 'Include', { fg = colors.magenta })
    highlight(0, 'Define', { fg = colors.magenta })
    highlight(0, 'Macro', { fg = colors.yellow })
    highlight(0, 'PreCondit', { fg = colors.yellow })

    -- Types
    highlight(0, 'Type', { fg = colors.cyan, bold = true })
    highlight(0, 'StorageClass', { fg = colors.magenta })
    highlight(0, 'Structure', { fg = colors.magenta })
    highlight(0, 'Typedef', { fg = colors.magenta })

    -- Special
    highlight(0, 'Special', { fg = colors.blue })
    highlight(0, 'SpecialChar', { fg = colors.yellow })
    highlight(0, 'Tag', { fg = colors.blue })
    highlight(0, 'Delimiter', { fg = colors.fg })
    highlight(0, 'SpecialComment', { fg = colors.grey })
    highlight(0, 'Debug', { fg = colors.red })

    -- UI
    highlight(0, 'Error', { fg = colors.red, bg = colors.bg, bold = true })
    highlight(0, 'Todo', { fg = colors.yellow, bg = colors.bg, bold = true })
    highlight(0, 'Underlined', { fg = colors.blue, underline = true })

    highlight(0, 'StatusLine', { fg = colors.fg, bg = colors.grey })
    highlight(0, 'StatusLineNC', { fg = colors.grey, bg = colors.bg })
    highlight(0, 'VertSplit', { fg = colors.grey, bg = colors.bg })

    highlight(0, 'TabLine', { fg = colors.fg, bg = colors.grey })
    highlight(0, 'TabLineFill', { fg = colors.fg, bg = colors.bg })
    highlight(0, 'TabLineSel', { fg = colors.bg, bg = colors.blue })

    highlight(0, 'Title', { fg = colors.blue, bold = true })
    highlight(0, 'LineNr', { fg = colors.grey, bg = colors.bg })
    highlight(0, 'CursorLineNr', { fg = colors.blue, bg = colors.bg, bold = true })
    highlight(0, 'CursorLine', { bg = colors.grey })
    highlight(0, 'CursorColumn', { bg = colors.grey })

    highlight(0, 'ColorColumn', { bg = colors.grey })
    highlight(0, 'SignColumn', { fg = colors.grey, bg = colors.bg })

    highlight(0, 'Folded', { fg = colors.grey, bg = colors.bg })
    highlight(0, 'FoldColumn', { fg = colors.grey, bg = colors.bg })

    highlight(0, 'Pmenu', { fg = colors.fg, bg = colors.grey })
    highlight(0, 'PmenuSel', { fg = colors.bg, bg = colors.blue })
    highlight(0, 'PmenuSbar', { bg = colors.grey })
    highlight(0, 'PmenuThumb', { bg = colors.fg })

    highlight(0, 'Search', { fg = colors.bg, bg = colors.yellow })
    highlight(0, 'IncSearch', { fg = colors.bg, bg = colors.green })
    highlight(0, 'Visual', { fg = colors.bg, bg = colors.blue })
    highlight(0, 'VisualNOS', { bg = colors.grey })

    highlight(0, 'MatchParen', { fg = colors.bg, bg = colors.cyan, bold = true })

    highlight(0, 'NonText', { fg = colors.grey })
    highlight(0, 'SpecialKey', { fg = colors.grey })

    highlight(0, 'Directory', { fg = colors.blue })
    highlight(0, 'ErrorMsg', { fg = colors.red, bg = colors.bg, bold = true })
    highlight(0, 'WarningMsg', { fg = colors.yellow })
    highlight(0, 'MoreMsg', { fg = colors.green })
    highlight(0, 'ModeMsg', { fg = colors.blue })
    highlight(0, 'Question', { fg = colors.blue })

    -- Diff
    highlight(0, 'DiffAdd', { fg = colors.green, bg = colors.bg })
    highlight(0, 'DiffChange', { fg = colors.yellow, bg = colors.bg })
    highlight(0, 'DiffDelete', { fg = colors.red, bg = colors.bg })
    highlight(0, 'DiffText', { fg = colors.blue, bg = colors.bg })

    -- LSP
    highlight(0, 'DiagnosticError', { fg = colors.red })
    highlight(0, 'DiagnosticWarn', { fg = colors.yellow })
    highlight(0, 'DiagnosticInfo', { fg = colors.blue })
    highlight(0, 'DiagnosticHint', { fg = colors.cyan })

    -- Treesitter
    highlight(0, '@function', { fg = colors.blue })
    highlight(0, '@method', { fg = colors.blue })
    highlight(0, '@parameter', { fg = colors.fg })
    highlight(0, '@property', { fg = colors.cyan })
    highlight(0, '@field', { fg = colors.cyan })
    highlight(0, '@constructor', { fg = colors.yellow })
    highlight(0, '@variable', { fg = colors.fg })
    highlight(0, '@constant', { fg = colors.cyan })
    highlight(0, '@string', { fg = colors.green })
    highlight(0, '@number', { fg = colors.yellow })
    highlight(0, '@boolean', { fg = colors.yellow })
    highlight(0, '@type', { fg = colors.cyan })
    highlight(0, '@keyword', { fg = colors.magenta })
    highlight(0, '@conditional', { fg = colors.magenta })
    highlight(0, '@repeat', { fg = colors.magenta })
    highlight(0, '@operator', { fg = colors.magenta })
    highlight(0, '@comment', { fg = colors.grey, italic = true })
    highlight(0, '@punctuation', { fg = colors.fg })

    -- Git signs
    highlight(0, 'GitSignsAdd', { fg = colors.green })
    highlight(0, 'GitSignsChange', { fg = colors.yellow })
    highlight(0, 'GitSignsDelete', { fg = colors.red })
end

return M
