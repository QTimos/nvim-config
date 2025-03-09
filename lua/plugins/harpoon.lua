return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		vim.keymap.set("n", "<leader>H", function()
			harpoon:list():add()
		end)
		vim.keymap.set("n", "<leader>h", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		-- vim.keymap.set("n", "<A-k>", function()
		-- 	harpoon:list():prev()
		-- end)
		-- vim.keymap.set("n", "<A-j>", function()
		-- 	harpoon:list():next()
		-- end)

		vim.keymap.set("n", "<A-k>", function()
			local files = harpoon:list()
			if files or #files then
				harpoon:list():prev()
			else
				print("No files to switch to, or you're trying to navigate too early after starting neovim.")
			end
		end)

		vim.keymap.set("n", "<A-j>", function()
			local files = harpoon:list()
			if files or #files then
				harpoon:list():next()
			else
				print("No files to switch to, or you're trying to navigate too early after starting neovim.")
			end
		end)
	end,
}
