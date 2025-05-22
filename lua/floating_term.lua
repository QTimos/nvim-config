local config = {
  width = 0.9,
  height = 0.9,
  border = 'rounded',
  winblend = 10,
  shell = nil,
  toggle_keymap = '<C-<>',
  terminal_mappings = true,
  
  border_color = "FloatingTermBorder",
  float_hl = "FloatingTermBackground",
  background_color = nil,
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
  local width = math.floor(vim.o.columns * config.width)
  local height = math.floor(vim.o.lines * config.height)
  
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  
  local content_width = width - config.padding.left - config.padding.right
  local content_height = height - config.padding.top - config.padding.bottom
  
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
  
  if config.border_color then
    vim.api.nvim_win_set_option(win, 'winhighlight', 
      'NormalFloat:' .. config.float_hl .. 
      ',FloatBorder:' .. config.border_color .. 
      ',FloatTitle:FloatingTermTitle')
  end
  
  return buf, win
end

local Terminal = {
  buf = nil,
  win = nil,
  job_id = nil,
  is_open = false,
}

function Terminal:create()
  if self.buf and vim.api.nvim_buf_is_valid(self.buf) then
    local _, win = create_float_window()
    vim.api.nvim_win_set_buf(win, self.buf)
    self.win = win
  else
    local buf, win = create_float_window()
    self.buf = buf
    self.win = win
    
    self.job_id = vim.fn.termopen(config.shell or vim.o.shell, {
      on_exit = function()
        -- if self.win and vim.api.nvim_win_is_valid(self.win) then
        --   vim.api.nvim_win_close(self.win, true)
        -- end
        -- self.is_open = false
      end
    })
    
    vim.bo[self.buf].buflisted = false

    if config.terminal_mappings then
      vim.api.nvim_buf_set_keymap(self.buf, 't', '<Esc>', [[<C-\><C-n>]], {noremap = true})
      vim.api.nvim_buf_set_keymap(self.buf, 't', config.toggle_keymap, 
        string.format([[<C-\><C-n>:lua require('floating_term').toggle()<CR>]], config.toggle_keymap), 
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

vim.api.nvim_set_keymap('n', config.toggle_keymap, 
  ':lua require("floating_term").toggle()<CR>', 
  {noremap = true, silent = true})

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
  
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      local nord = {
        polar_night = {
          nord0 = "#2E3440",
          nord1 = "#3B4252",
          nord2 = "#434C5E",
          nord3 = "#4C566A" 
        },
        snow_storm = {
          nord4 = "#D8DEE9",
          nord5 = "#E5E9F0",
          nord6 = "#ECEFF4"
        },
        frost = {
          nord7 = "#8FBCBB",
          nord8 = "#88C0D0",
          nord9 = "#81A1C1",
          nord10 = "#5E81AC"
        },
        aurora = {
          nord11 = "#BF616A",
          nord12 = "#D08770",
          nord13 = "#EBCB8B",
          nord14 = "#A3BE8C",
          nord15 = "#B48EAD"
        }
      }
      
      vim.api.nvim_set_hl(0, "FloatingTermBorder", { 
        fg = nord.frost.nord9,
        bold = true 
      })
      
      vim.api.nvim_set_hl(0, "FloatingTermBackground", { 
        bg = nord.polar_night.nord0
      })
      
      vim.api.nvim_set_hl(0, "FloatingTermTitle", {
        fg = nord.frost.nord8,
        bold = true
      })
    end,
  })
  
  if config.border_color == "FloatBorder" then
    config.border_color = "FloatingTermBorder"
  end
  
  if config.float_hl == "NormalFloat" then
    config.float_hl = "FloatingTermBackground" 
  end
  
  vim.cmd("doautocmd ColorScheme")
end

return M
