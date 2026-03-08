return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		vim.keymap.set("n", "<leader>H", function()
			harpoon:list():add()
		end, { desc = "Harpoon: add file" })

		vim.keymap.set("n", "<leader>h", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon: toggle menu" })

		vim.keymap.set("n", "<A-k>", function()
			harpoon:list():prev()
		end, { desc = "Harpoon: prev file" })

		vim.keymap.set("n", "<A-j>", function()
			harpoon:list():next()
		end, { desc = "Harpoon: next file" })

		-- Direct slot access
		for i = 1, 4 do
			vim.keymap.set("n", "<A-" .. i .. ">", function()
				harpoon:list():select(i)
			end, { desc = "Harpoon: jump to file " .. i })
		end
	end,
}
