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
  
  -- Create the window and return its buffer and window handles
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, opts)
  
  -- Set window-local options
  vim.wo[win].winblend = config.winblend
  vim.wo[win].cursorline = true
  
  -- Apply Nord-themed colors to the window
  if config.border_color then
    -- Set border and title highlights
    vim.api.nvim_win_set_option(win, 'winhighlight', 
      'NormalFloat:' .. config.float_hl .. 
      ',FloatBorder:' .. config.border_color .. 
      ',FloatTitle:FloatingTermTitle')
  end
  
  return buf, win
end

-- Terminal state management
local Terminal = {
  buf = nil,
  win = nil,
  job_id = nil,
  is_open = false,
}

-- Function to create or focus the terminal
function Terminal:create()
  if self.buf and vim.api.nvim_buf_is_valid(self.buf) then
    -- Terminal buffer exists, create a new window and set the buffer
    local _, win = create_float_window()
    vim.api.nvim_win_set_buf(win, self.buf)
    self.win = win
  else
    -- Create new terminal buffer
    local buf, win = create_float_window()
    self.buf = buf
    self.win = win
    
    -- Start the terminal
    self.job_id = vim.fn.termopen(config.shell or vim.o.shell, {
      on_exit = function()
        -- Optional: Close window when terminal process exits
        -- if self.win and vim.api.nvim_win_is_valid(self.win) then
        --   vim.api.nvim_win_close(self.win, true)
        -- end
        -- self.is_open = false
      end
    })
    
    -- Set buffer options for terminal
    vim.bo[self.buf].buflisted = false
    
    -- Terminal buffer-local mappings
    if config.terminal_mappings then
      -- Auto-enter insert mode when focusing terminal
      vim.api.nvim_buf_set_keymap(self.buf, 't', '<Esc>', [[<C-\><C-n>]], {noremap = true})
      vim.api.nvim_buf_set_keymap(self.buf, 't', config.toggle_keymap, 
        string.format([[<C-\><C-n>:lua require('floating_term').toggle()<CR>]], config.toggle_keymap), 
        {noremap = true, silent = true})

      -- Add normal mode toggle for when not in insert mode
      vim.api.nvim_buf_set_keymap(self.buf, 'n', config.toggle_keymap,
        ':lua require("floating_term").toggle()<CR>', 
        {noremap = true, silent = true})
    end
    
    -- Auto-enter insert mode when opening terminal
    vim.cmd('startinsert')
  end
  
  self.is_open = true
end

-- Function to toggle terminal visibility
function Terminal:toggle()
  if self.is_open and self.win and vim.api.nvim_win_is_valid(self.win) then
    -- Close the window
    vim.api.nvim_win_close(self.win, true)
    self.win = nil  -- Clear window reference when closing
    self.is_open = false
  else
    -- Open or reopen terminal
    self:create()
  end
end

-- Set up global keymapping for toggling the terminal
vim.api.nvim_set_keymap('n', config.toggle_keymap, 
  ':lua require("floating_term").toggle()<CR>', 
  {noremap = true, silent = true})

-- Module interface
local M = {}

-- User-facing toggle function
function M.toggle()
  Terminal:toggle()
end

-- Setup function for custom configuration
function M.setup(user_config)
  -- Merge user config with defaults
  if user_config then
    for k, v in pairs(user_config) do
      if type(v) == "table" and type(config[k]) == "table" then
        -- Deep merge for nested tables like padding
        for sk, sv in pairs(v) do
          config[k][sk] = sv
        end
      else
        config[k] = v
      end
    end
  end
  
  -- Register keymap
  vim.api.nvim_set_keymap('n', config.toggle_keymap, 
    ':lua require("floating_term").toggle()<CR>', 
    {noremap = true, silent = true})

  -- Make terminal window a nice experience
  vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
      -- Disable line numbers in terminal
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      -- Start in insert mode
      vim.cmd('startinsert')
    end,
  })
  
  -- Define Nord-themed highlight colors
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      -- Nord color palette
      local nord = {
        polar_night = {
          nord0 = "#2E3440", -- Dark background
          nord1 = "#3B4252", -- Lighter background
          nord2 = "#434C5E", -- Selection background
          nord3 = "#4C566A"  -- Bright background / dim foreground
        },
        snow_storm = {
          nord4 = "#D8DEE9", -- Bright foreground
          nord5 = "#E5E9F0", -- Medium bright foreground
          nord6 = "#ECEFF4"  -- Bright foreground
        },
        frost = {
          nord7 = "#8FBCBB", -- Teal
          nord8 = "#88C0D0", -- Light blue
          nord9 = "#81A1C1", -- Medium blue
          nord10 = "#5E81AC" -- Dark blue
        },
        aurora = {
          nord11 = "#BF616A", -- Red
          nord12 = "#D08770", -- Orange
          nord13 = "#EBCB8B", -- Yellow
          nord14 = "#A3BE8C", -- Green
          nord15 = "#B48EAD"  -- Purple
        }
      }
      
      -- Create Nord-themed border highlight
      vim.api.nvim_set_hl(0, "FloatingTermBorder", { 
        fg = nord.frost.nord9,   -- Medium blue for border
        bold = true 
      })
      
      -- Create Nord-themed background for the terminal
      vim.api.nvim_set_hl(0, "FloatingTermBackground", { 
        bg = nord.polar_night.nord0  -- Dark background
      })
      
      -- Create Nord-themed title highlight
      vim.api.nvim_set_hl(0, "FloatingTermTitle", {
        fg = nord.frost.nord8,  -- Light blue for title
        bold = true
      })
    end,
  })
  
  -- Set default Nord-themed configuration if not specified
  if config.border_color == "FloatBorder" then
    config.border_color = "FloatingTermBorder"
  end
  
  if config.float_hl == "NormalFloat" then
    config.float_hl = "FloatingTermBackground" 
  end
  
  -- Trigger the highlights for the current colorscheme
  vim.cmd("doautocmd ColorScheme")
end

return M

-- Example setup in init.lua with Nord theme:
--[[
require('floating_term').setup({
  -- Basic configuration
  width = 0.85,
  height = 0.8,
  toggle_keymap = '<C-\\>',
  
  -- Nord-themed visual customization
  border = 'rounded',    -- or 'single', 'double', 'shadow'
  winblend = 10,         -- transparency (0-100)
  border_color = "FloatingTermBorder",  -- uses Nord frost colors
  float_hl = "FloatingTermBackground",  -- uses Nord polar night colors
  title = " Terminal ",
  title_pos = "center",  -- or 'left', 'right'
  
  -- Extra padding
  padding = {
    top = 1,
    right = 2,
    bottom = 1,
    left = 2
  }
})
--]]

--[[ Nord color scheme reference:
Polar Night (dark/background)
  nord0: #2E3440 - Base background
  nord1: #3B4252 - Lighter background
  nord2: #434C5E - Selection background
  nord3: #4C566A - Bright background/dim foreground

Snow Storm (light/foreground)
  nord4: #D8DEE9 - Bright foreground
  nord5: #E5E9F0 - Medium bright foreground
  nord6: #ECEFF4 - Bright foreground

Frost (blues)
  nord7: #8FBCBB - Teal
  nord8: #88C0D0 - Light blue (used for title)
  nord9: #81A1C1 - Medium blue (used for border)
  nord10: #5E81AC - Dark blue

Aurora (accents)
  nord11: #BF616A - Red
  nord12: #D08770 - Orange
  nord13: #EBCB8B - Yellow
  nord14: #A3BE8C - Green
  nord15: #B48EAD - Purple
--]]
