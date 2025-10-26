return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		dapui.setup()
		
		-- codelldb adapter for C, C++ and Rust (already installed via Mason)
		dap.adapters.codelldb = {
			type = 'server',
			port = "${port}",
			executable = {
				command = vim.fn.stdpath('data') .. '/mason/bin/codelldb',
				args = {"--port", "${port}"},
			}
		}
		
		-- Configuration for C
		dap.configurations.c = {
			{
				name = "Launch file",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
				cwd = '${workspaceFolder}',
				stopOnEntry = false,
			},
			{
				name = "Attach to process",
				type = "codelldb",
				request = "attach",
				pid = function()
					local process_picker = require('dap.utils').pick_process
					return process_picker()
				end,
				cwd = "${workspaceFolder}",
			},
			{
				name = "Attach to gdbserver",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
				cwd = '${workspaceFolder}',
				initCommands = {
					'target remote localhost:1234',
				},
			},
		}
		
		-- Same configurations for C++, Rust, and Zig
		dap.configurations.cpp = dap.configurations.c
		dap.configurations.rust = dap.configurations.c
		dap.configurations.zig = dap.configurations.c
		
		-- debugpy for Python
		dap.adapters.python = function(cb, config)
			if config.request == "attach" then
				local port = (config.connect or config).port
				local host = (config.connect or config).host or "127.0.0.1"
				cb({
					type = "server",
					port = assert(port, "`connect.port` is required for a python `attach` configuration"),
					host = host,
					options = {
						source_filetype = "python",
					},
				})
			else
				cb({
					type = "executable",
					command = vim.fn.stdpath('data') .. '/mason/packages/debugpy/venv/bin/python',
					args = { "-m", "debugpy.adapter" },
					options = {
						source_filetype = "python",
					},
				})
			end
		end
		
		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				pythonPath = function()
					local cwd = vim.fn.getcwd()
					if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
						return cwd .. "/venv/bin/python"
					elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
						return cwd .. "/.venv/bin/python"
					else
						return "/usr/bin/python"
					end
				end,
			},
		}
		
		-- UI listeners
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
		
		-- Keymaps
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
		vim.keymap.set("n", "<leader>B", function()
			dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
		end, { desc = "Conditional Breakpoint" })
		
		vim.keymap.set("n", "<F1>", dap.continue, { desc = "Debug: Continue" })
		vim.keymap.set("n", "<F2>", dap.step_into, { desc = "Debug: Step Into" })
		vim.keymap.set("n", "<F3>", dap.step_over, { desc = "Debug: Step Over" })
		vim.keymap.set("n", "<F4>", dap.step_out, { desc = "Debug: Step Out" })
		vim.keymap.set("n", "<F5>", dap.repl.toggle, { desc = "Debug: Toggle REPL" })
		vim.keymap.set("n", "<F9>", dap.run_to_cursor, { desc = "Debug: Run to Cursor" })
		vim.keymap.set("n", "<F10>", dap.terminate, { desc = "Debug: Terminate" })
		
		-- Additional useful keymaps
		vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { desc = "Debug: Toggle UI" })
		vim.keymap.set("n", "<leader>de", function() dapui.eval() end, { desc = "Debug: Eval" })
	end,
}
