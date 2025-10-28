local M = {}

local ascii_art = {
	"        :::      ::::::::",
	"      :+:      :+:    :+:",
	"    +:+ +:+         +:+  ",
	"  +#+  +:+       +#+     ",
	"+#+#+#+#+#+   +#+        ",
	"     #+#    #+#          ",
	"    ###   ########.fr    "
}

local config = {
	length = 80,
	margin = 5,
	user = nil,
	mail = nil,
}

local file_types = {
	{ pattern = "%.c$", chars = {"/*", "*/", "*"} },
	{ pattern = "%.h$", chars = {"/*", "*/", "*"} },
	{ pattern = "%.cc$", chars = {"/*", "*/", "*"} },
	{ pattern = "%.hh$", chars = {"/*", "*/", "*"} },
	{ pattern = "%.cpp$", chars = {"/*", "*/", "*"} },
	{ pattern = "%.hpp$", chars = {"/*", "*/", "*"} },
	{ pattern = "%.tpp$", chars = {"/*", "*/", "*"} },
	{ pattern = "%.ipp$", chars = {"/*", "*/", "*"} },
	{ pattern = "%.cxx$", chars = {"/*", "*/", "*"} },
	{ pattern = "%.go$", chars = {"/*", "*/", "*"} },
	{ pattern = "%.rs$", chars = {"/*", "*/", "*"} },
	{ pattern = "%.php$", chars = {"/*", "*/", "*"} },
	{ pattern = "%.java$", chars = {"/*", "*/", "*"} },
	{ pattern = "%.kt$", chars = {"/*", "*/", "*"} },
	{ pattern = "%.kts$", chars = {"/*", "*/", "*"} },
	{ pattern = "%.htm$", chars = {"<!--", "-->", "*"} },
	{ pattern = "%.html$", chars = {"<!--", "-->", "*"} },
	{ pattern = "%.xml$", chars = {"<!--", "-->", "*"} },
	{ pattern = "%.js$", chars = {"//", "//", "*"} },
	{ pattern = "%.ts$", chars = {"//", "//", "*"} },
	{ pattern = "%.tex$", chars = {"%", "%", "*"} },
	{ pattern = "%.ml$", chars = {"(*", "*)", "*"} },
	{ pattern = "%.mli$", chars = {"(*", "*)", "*"} },
	{ pattern = "%.mll$", chars = {"(*", "*)", "*"} },
	{ pattern = "%.mly$", chars = {"(*", "*)", "*"} },
	{ pattern = "%.vim$", chars = {'"', '"', "*"} },
	{ pattern = "vimrc$", chars = {'"', '"', "*"} },
	{ pattern = "%.el$", chars = {";", ";", "*"} },
	{ pattern = "emacs$", chars = {";", ";", "*"} },
	{ pattern = "%.asm$", chars = {";", ";", "*"} },
	{ pattern = "%.f90$", chars = {"!", "!", "/"} },
	{ pattern = "%.f95$", chars = {"!", "!", "/"} },
	{ pattern = "%.f03$", chars = {"!", "!", "/"} },
	{ pattern = "%.f$", chars = {"!", "!", "/"} },
	{ pattern = "%.for$", chars = {"!", "!", "/"} },
	{ pattern = "%.lua$", chars = {"--", "--", "-"} },
	{ pattern = "%.py$", chars = {"#", "#", "*"} },
	{ pattern = "%.sh$", chars = {"#", "#", "*"} },
}

local function get_user()
	if config.user then
		return config.user
	end
	local user = vim.env.USER or "marvin"
	return user
end

local function get_mail()
	if config.mail then
		return config.mail
	end
	local mail = vim.env.MAIL or "marvin@42.fr"
	return mail
end

local function get_filename()
	local filename = vim.fn.expand("%:t")
	if filename == "" then
		filename = "< new >"
	end
	return filename
end

local function get_date()
	return os.date("%Y/%m/%d %H:%M:%S")
end

local function get_filetype()
	local filename = get_filename()
	
	for _, ft in ipairs(file_types) do
		if filename:match(ft.pattern) then
			return ft.chars[1], ft.chars[2], ft.chars[3]
		end
	end
	
	-- Default to hash comments
	return "#", "#", "*"
end

local function get_ascii(n)
	return ascii_art[n - 2]
end

local function create_textline(left, right, start_char, end_char)
	local max_left_len = config.length - config.margin * 2 - #right
	local left_text = left:sub(1, max_left_len)
	
	local spaces = config.length - config.margin * 2 - #left_text - #right
	if spaces < 0 then
		spaces = 0
	end

	local left_margin = string.rep(" ", config.margin - #start_char)
	local right_margin = string.rep(" ", config.margin - #end_char)
	
	return start_char .. left_margin .. left_text .. string.rep(" ", spaces) .. right .. right_margin .. end_char
end

local function create_line(n, start_char, end_char, fill_char)
	if n == 1 or n == 11 then
		-- Top and bottom line
		local fill = string.rep(fill_char, config.length - #start_char - #end_char - 2)
		return start_char .. " " .. fill .. " " .. end_char
	elseif n == 2 or n == 10 then
		-- Blank line
		return create_textline("", "", start_char, end_char)
	elseif n == 3 or n == 5 or n == 7 then
		-- Empty with ASCII art
		return create_textline("", get_ascii(n), start_char, end_char)
	elseif n == 4 then
		-- Filename
		return create_textline(get_filename(), get_ascii(n), start_char, end_char)
	elseif n == 6 then
		-- Author
		local author_text = "By: " .. get_user() .. " <" .. get_mail() .. ">"
		return create_textline(author_text, get_ascii(n), start_char, end_char)
	elseif n == 8 then
		-- Created
		local created_text = "Created: " .. get_date() .. " by " .. get_user()
		return create_textline(created_text, get_ascii(n), start_char, end_char)
	elseif n == 9 then
		-- Updated
		local updated_text = "Updated: " .. get_date() .. " by " .. get_user()
		return create_textline(updated_text, get_ascii(n), start_char, end_char)
	end
end

local function is_rebasing()
	local ok, result = pcall(function()
		local handle = io.popen("git rev-parse --git-dir 2>/dev/null")
		if not handle then return false end
		local git_dir = handle:read("*a"):gsub("%s+$", "")
		handle:close()
		
		if git_dir == "" then return false end
		
		local rebase_check = io.popen("ls " .. git_dir .. " 2>/dev/null | grep -c rebase")
		if not rebase_check then return false end
		local count = rebase_check:read("*a")
		rebase_check:close()
		
		return tonumber(count) and tonumber(count) > 0
	end)
	
	return ok and result or false
end

local function insert_header()
	local start_char, end_char, fill_char = get_filetype()
	local lines = {}
	
	-- Generate all header lines
	for i = 1, 11 do
		table.insert(lines, create_line(i, start_char, end_char, fill_char))
	end
	
	-- Add empty line after header
	table.insert(lines, "")
	
	-- Insert at the beginning of the file
	vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
end

local function update_header()
	local start_char, end_char, fill_char = get_filetype()
	
	-- Check if we have at least 9 lines
	local line_count = vim.api.nvim_buf_line_count(0)
	if line_count < 9 then
		return true
	end
	
	local line9 = vim.api.nvim_buf_get_lines(0, 8, 9, false)[1]
	
	if not line9 then
		return true
	end

	local left_margin = string.rep(" ", config.margin - #start_char)
	local check_string = start_char .. left_margin .. "Updated: "
	
	-- Check if line 9 starts with the updated string
	if line9:sub(1, #check_string) == check_string then
		local modified = vim.bo.modified
		local rebasing = is_rebasing()
		
		if modified and not rebasing then
			-- Update line 9 (Updated)
			local new_line9 = create_line(9, start_char, end_char, fill_char)
			vim.api.nvim_buf_set_lines(0, 8, 9, false, {new_line9})
		end
		
		if not rebasing then
			-- Update line 4 (Filename)
			local new_line4 = create_line(4, start_char, end_char, fill_char)
			vim.api.nvim_buf_set_lines(0, 3, 4, false, {new_line4})
		end
		
		return false
	end
	
	return true
end

local function fix_merge_conflict()
	local start_char, end_char, fill_char = get_filetype()
	local left_margin = string.rep(" ", config.margin - #start_char)
	local check_string = start_char .. left_margin .. "Updated: "
	
	local line_count = vim.api.nvim_buf_line_count(0)
	if line_count < 14 then
		return
	end
	
	local line9 = vim.api.nvim_buf_get_lines(0, 8, 9, false)[1] or ""
	local line10 = vim.api.nvim_buf_get_lines(0, 9, 10, false)[1] or ""
	local line11 = vim.api.nvim_buf_get_lines(0, 10, 11, false)[1] or ""
	local line13 = vim.api.nvim_buf_get_lines(0, 12, 13, false)[1] or ""
	
	-- Fix conflict on 'Updated:' line
	if line9:match("<<<<<<<") and line11:match("=======") and line13:match(">>>>>>>") 
		and line10:sub(1, #check_string) == check_string then
		local new_lines = {}
		for i = 9, 11 do
			table.insert(new_lines, create_line(i, start_char, end_char, fill_char))
		end
		vim.api.nvim_buf_set_lines(0, 8, 11, false, new_lines)
		vim.api.nvim_buf_set_lines(0, 11, 15, false, {})
		vim.notify("42header conflicts automatically resolved!", vim.log.levels.INFO)
		return
	end
	
	-- Fix conflict on both 'Created:' and 'Updated:'
	if line_count < 15 then
		return
	end
	
	local line8 = vim.api.nvim_buf_get_lines(0, 7, 8, false)[1] or ""
	local line14 = vim.api.nvim_buf_get_lines(0, 13, 14, false)[1] or ""
	
	if line8:match("<<<<<<<") and line11:match("=======") and line14:match(">>>>>>>") 
		and line10:sub(1, #check_string) == check_string then
		local new_lines = {}
		for i = 8, 11 do
			table.insert(new_lines, create_line(i, start_char, end_char, fill_char))
		end
		vim.api.nvim_buf_set_lines(0, 7, 11, false, new_lines)
		vim.api.nvim_buf_set_lines(0, 11, 16, false, {})
		vim.notify("42header conflicts automatically resolved!", vim.log.levels.INFO)
	end
end

local function stdheader()
	if update_header() then
		insert_header()
	end
end

-- Setup function
function M.setup(opts)
	opts = opts or {}
	config.user = opts.user or config.user
	config.mail = opts.mail or config.mail
	config.length = opts.length or config.length
	config.margin = opts.margin or config.margin
	
	-- Create user command
	vim.api.nvim_create_user_command("Stdheader", function()
		stdheader()
	end, {})
	
	-- Set up keybinding
	vim.keymap.set("n", "<F1>", ":Stdheader<CR>", { silent = true, desc = "Insert 42 header" })
	
	-- Set up autocommands
	local group = vim.api.nvim_create_augroup("stdheader", { clear = true })
	
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = group,
		pattern = "*",
		callback = function()
			update_header()
		end,
	})
	
	vim.api.nvim_create_autocmd("BufReadPost", {
		group = group,
		pattern = "*",
		callback = function()
			fix_merge_conflict()
		end,
	})
end

-- Manual trigger function
M.insert = stdheader
M.update = update_header

return M
