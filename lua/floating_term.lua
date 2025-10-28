local config = {
    width = 0.9,
    height = 0.9,
    border = 'rounded',
    winblend = 0,
    shell = nil,
    toggle_keymap = '<C-C>',
    terminal_mappings = true,

    padding = {
        top = 1,
        right = 6,
        bottom = 1, 
        left = 6
    },
    title = " Terminal ",
    title_pos = "center",
}

local function create_float_window()
    -- Calculate content dimensions first
    local total_width = math.floor(vim.o.columns * config.width)
    local total_height = math.floor(vim.o.lines * config.height)

    local content_width = total_width - config.padding.left - config.padding.right - 2 -- -2 for borders
    local content_height = total_height - config.padding.top - config.padding.bottom - 2 -- -2 for borders

    -- Center based on total dimensions (fixed calculation)
    local row = math.floor((vim.o.lines - total_height) / 2)
    local col = math.floor((vim.o.columns - total_width) / 2)

    local opts = {
        relative = 'editor',
        row = row,
        col = col,
        width = content_width,
        height = content_height,
        style = 'minimal',
        border = config.border,
        title = config.title,
        title_pos = config.title_pos,
    }

    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, opts)

    vim.wo[win].winblend = config.winblend
    vim.wo[win].cursorline = true

    vim.api.nvim_win_set_option(win, 'winhighlight', 
        'NormalFloat:FloatingTermBackground,FloatBorder:FloatingTermBorder,FloatTitle:FloatingTermTitle')

    return buf, win
end

local Terminal = {
    buf = nil,
    win = nil,
    job_id = nil,
    is_open = false,
}

function Terminal:create()
    -- Get the directory of the current buffer before creating terminal
    local current_buf = vim.api.nvim_get_current_buf()
    local buf_name = vim.api.nvim_buf_get_name(current_buf)
    local cwd = vim.fn.getcwd()
    
    if buf_name ~= "" then
        -- Get directory of current file
        cwd = vim.fn.fnamemodify(buf_name, ":p:h")
    end

    if self.buf and vim.api.nvim_buf_is_valid(self.buf) then
        local _, win = create_float_window()
        vim.api.nvim_win_set_buf(win, self.buf)
        self.win = win
    else
        local buf, win = create_float_window()
        self.buf = buf
        self.win = win

        self.job_id = vim.fn.termopen(config.shell or vim.o.shell, {
            cwd = cwd,
            on_exit = function()
                if self.win and vim.api.nvim_win_is_valid(self.win) then
                    vim.api.nvim_win_close(self.win, true)
                end
                self.is_open = false
            end
        })

        vim.bo[self.buf].buflisted = false

        if config.terminal_mappings then
            vim.api.nvim_buf_set_keymap(self.buf, 't', '<Esc>', [[<C-\><C-n>]], {noremap = true})
            vim.api.nvim_buf_set_keymap(self.buf, 't', config.toggle_keymap, 
                [[<C-\><C-n>:lua require('floating_term').toggle()<CR>]], 
                {noremap = true, silent = true})
            vim.api.nvim_buf_set_keymap(self.buf, 'n', config.toggle_keymap,
                ':lua require("floating_term").toggle()<CR>', 
                {noremap = true, silent = true})
        end

        vim.cmd('startinsert')
    end

    self.is_open = true
end

function Terminal:toggle()
    if self.is_open and self.win and vim.api.nvim_win_is_valid(self.win) then
        vim.api.nvim_win_close(self.win, true)
        self.win = nil
        self.is_open = false
    else
        self:create()
    end
end

local M = {}

function M.toggle()
    Terminal:toggle()
end

function M.setup(user_config)
    if user_config then
        for k, v in pairs(user_config) do
            if type(v) == "table" and type(config[k]) == "table" then
                for sk, sv in pairs(v) do
                    config[k][sk] = sv
                end
            else
                config[k] = v
            end
        end
    end

    vim.api.nvim_set_keymap('n', config.toggle_keymap, 
        ':lua require("floating_term").toggle()<CR>', 
        {noremap = true, silent = true})

    vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*",
        callback = function()
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.cmd('startinsert')
        end,
    })

    local function setup_colors()
        local bg = vim.api.nvim_get_hl(0, {name = 'Normal'}).bg
        local border_fg = vim.api.nvim_get_hl(0, {name = 'Comment'}).fg

        if not bg then bg = 0x0F111A end
        if not border_fg then border_fg = 0x7AA2F7 end

        local term_bg = bg + 0x0A0A0A

        vim.api.nvim_set_hl(0, "FloatingTermBorder", { 
            fg = border_fg,
            bold = true 
        })

        vim.api.nvim_set_hl(0, "FloatingTermBackground", { 
            bg = term_bg
        })

        vim.api.nvim_set_hl(0, "FloatingTermTitle", {
            fg = border_fg,
            bold = true
        })
    end

    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = setup_colors,
    })
    setup_colors()
end

return M
