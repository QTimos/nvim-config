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
		
		-- vscode-cpptools adapter for C, C++ and Rust
		dap.adapters.cppdbg = {
			id = 'cppdbg',
			type = 'executable',
			command = vim.fn.stdpath('data') .. '/mason/bin/OpenDebugAD7',
		}

		-- vscode-cpptools configuration for C
		dap.configurations.c = {
			{
				name = "Launch file",
				type = "cppdbg",
				request = "launch",
				program = function()
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
				cwd = '${workspaceFolder}',
				stopAtEntry = true,
				setupCommands = {
					{
						text = '-enable-pretty-printing',
						description = 'enable pretty printing',
						ignoreFailures = false
					},
				},
			},
			{
				name = "Attach to process",
				type = "cppdbg",
				request = "attach",
				processId = function()
					local process_picker = require('dap.utils').pick_process
					return process_picker()
				end,
				program = function()
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
				cwd = "${workspaceFolder}",
				setupCommands = {
					{
						text = '-enable-pretty-printing',
						description = 'enable pretty printing',
						ignoreFailures = false
					},
				},
			},
			{
				name = "Attach to gdbserver",
				type = "cppdbg",
				request = "launch",
				MIMode = "gdb",
				miDebuggerServerAddress = "localhost:1234",
				miDebuggerPath = "/usr/bin/gdb",
				program = function()
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
				cwd = '${workspaceFolder}',
				setupCommands = {
					{
						text = '-enable-pretty-printing',
						description = 'enable pretty printing',
						ignoreFailures = false
					},
				},
			},
		}

		-- the same configuration for C++ and Rust
		dap.configurations.cpp = dap.configurations.c
		dap.configurations.rust = dap.configurations.c
		
		-- debugpy for Python
		dap.adapters.python = function(cb, config)
			if config.request == "attach" then
				---@diagnostic disable-next-line: undefined-field
				local port = (config.connect or config).port
				---@diagnostic disable-next-line: undefined-field
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
					command = "/home/timos/.virtualenvs/debugpy/bin/python",
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
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, {})
		vim.keymap.set("n", "<F1>", dap.continue, {})
		vim.keymap.set("n", "<F2>", dap.step_into, {})
		vim.keymap.set("n", "<F3>", dap.step_over, {})
		vim.keymap.set("n", "<F4>", dap.run_to_cursor, {})
		vim.keymap.set("n", "<F5>", dap.repl.toggle, {})
	end,
}
