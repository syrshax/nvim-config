local M = {}

-- Get Python paths with environment awareness
local function get_debugger_path()
	-- Store the original VIRTUAL_ENV
	local original_venv = os.getenv("VIRTUAL_ENV")
	-- Clear it temporarily so it doesn't interfere with debugger path resolution
	vim.env.VIRTUAL_ENV = nil

	local debugger_path = os.getenv("HOME") .. "/.local/nvim-python-debugger/env/bin/python"

	-- Restore original VIRTUAL_ENV
	if original_venv then
		vim.env.VIRTUAL_ENV = original_venv
	end

	return debugger_path
end

local function get_python_path()
	local venv_path = os.getenv("VIRTUAL_ENV")
	local poetry_path = vim.fn.trim(vim.fn.system("poetry env info -p"))

	if venv_path then
		return venv_path .. "/bin/python"
	elseif poetry_path ~= "" then
		return poetry_path .. "/bin/python"
	else
		return vim.fn.exepath("python3") or vim.fn.exepath("python")
	end
end

function M.setup()
	-- Add highlighting
	vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#FF0000", bold = true })
	vim.api.nvim_set_hl(0, "DapBreakpointLine", { bg = "#331111" })
	vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef", bold = true })
	vim.api.nvim_set_hl(0, "DapLogPointLine", { bg = "#112233" })
	vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379", bold = true })
	vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#112211" })

	-- Setup Breakpoint Signs
	vim.fn.sign_define("DapBreakpoint", {
		text = "●",
		texthl = "DapBreakpoint",
		linehl = "DapBreakpointLine",
		numhl = "DapBreakpoint",
	})
	vim.fn.sign_define("DapBreakpointCondition", {
		text = "◆",
		texthl = "DapBreakpoint",
		linehl = "DapBreakpointLine",
		numhl = "DapBreakpoint",
	})
	vim.fn.sign_define("DapLogPoint", {
		text = "◆",
		texthl = "DapLogPoint",
		linehl = "DapLogPointLine",
		numhl = "DapLogPoint",
	})
	vim.fn.sign_define("DapStopped", {
		text = "▶",
		texthl = "DapStopped",
		linehl = "DapStoppedLine",
		numhl = "DapStopped",
	})
	vim.fn.sign_define("DapBreakpointRejected", {
		text = "●",
		texthl = "DapBreakpointRejected",
		linehl = "DapBreakpointLine",
		numhl = "DapBreakpointRejected",
	})

	-- Ensure sign column is always visible
	vim.opt.signcolumn = "yes"

	local dap = require("dap")
	local dapui = require("dapui")
	local dap_python = require("dap-python")

	-- Get the project root directory
	local project_root = vim.fn.getcwd()

	-- Setup Python adapter using dedicated debugger environment
	dap.adapters.python = {
		type = "executable",
		command = get_debugger_path(),
		args = { "-m", "debugpy.adapter" },
		options = {
			env = {
				VIRTUAL_ENV = os.getenv("HOME") .. "/.local/nvim-python-debugger/env",
				PATH = os.getenv("PATH"),
				PYTHONPATH = project_root, -- Set PYTHONPATH to project root
			},
		},
	}

	-- Function to get environment with proper PYTHONPATH
	local function get_env()
		local env = {}
		-- Copy current environment
		for k, v in pairs(vim.fn.environ()) do
			env[k] = v
		end

		-- Set PYTHONPATH to include project root
		if env.PYTHONPATH then
			env.PYTHONPATH = project_root .. ":" .. env.PYTHONPATH
		else
			env.PYTHONPATH = project_root
		end

		-- Add src directory to PYTHONPATH if it exists
		if vim.fn.isdirectory(project_root .. "/src") == 1 then
			env.PYTHONPATH = project_root .. "/src:" .. env.PYTHONPATH
		end

		return env
	end

	-- Basic configurations for Python
	dap.configurations.python = {
		{
			type = "python",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			pythonPath = function()
				return get_python_path()
			end,
			env = get_env,
		},
	}

	-- Configure Python test debugging
	dap_python.setup(get_python_path())
	dap_python.test_runner = "pytest"

	-- Add test debugging configurations
	table.insert(dap.configurations.python, {
		type = "python",
		request = "launch",
		name = "Python: Debug Tests",
		module = "pytest",
		args = {
			"-v",
			"-s",
			"--no-cov",
			"${file}",
			"-k",
			"${TestName}",
		},
		console = "integratedTerminal",
		justMyCode = false,
		pythonPath = function()
			return get_python_path()
		end,
		env = get_env, -- Use the same environment function
	})

	-- Add debug info command with more detail
	vim.keymap.set("n", "<leader>di", function()
		local env = get_env() -- Get the actual environment that will be used
		local info = {
			"DAP Python Configuration:",
			"Debugger Path: " .. get_debugger_path(),
			"Project Path: " .. get_python_path(),
			"VIRTUAL_ENV: " .. (os.getenv("VIRTUAL_ENV") or "not set"),
			"Current Directory: " .. project_root,
			"Environment Variables:",
			"PYTHONPATH: " .. (env.PYTHONPATH or "not set"),
			"VIRTUAL_ENV: " .. (env.VIRTUAL_ENV or "not set"),
			"PATH: " .. (env.PATH or "not set"),
		}

		-- Add src directory info
		if vim.fn.isdirectory(project_root .. "/src") == 1 then
			table.insert(info, "src directory: Found and added to PYTHONPATH")
		else
			table.insert(info, "src directory: Not found")
		end

		vim.notify(table.concat(info, "\n"), vim.log.levels.INFO)
	end, { desc = "Show Debug Environment Info" })

	-- Setup DAP UI
	dapui.setup({
		layouts = {
			{
				elements = {
					{ id = "scopes", size = 0.25 },
					{ id = "breakpoints", size = 0.25 },
					{ id = "stacks", size = 0.25 },
					{ id = "watches", size = 0.25 },
				},
				position = "right",
				size = 40,
			},
			{
				elements = {
					{ id = "repl", size = 0.5 },
					{ id = "console", size = 0.5 },
				},
				position = "bottom",
				size = 10,
			},
		},
	})

	-- Auto-open DAP UI
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end

	-- Basic debugging keymaps
	vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
	vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
	vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
	vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
	vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
	vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
	-- Watch expressions
	vim.keymap.set("n", "<leader>dw", function()
		require("dapui").elements.watches.add()
	end, { desc = "Add Watch Expression" })

	vim.keymap.set("n", "<leader>dW", function()
		local widgets = require("dap.ui.widgets")
		widgets.hover()
	end, { desc = "Hover Value" })

	-- Also add a keymap for evaluating under cursor
	vim.keymap.set("n", "<leader>de", function()
		require("dapui").eval()
	end, { desc = "Evaluate Under Cursor" })

	-- Optional: Add visual mode evaluation
	vim.keymap.set("v", "<leader>de", function()
		require("dapui").eval()
	end, { desc = "Evaluate Selection" })

	-- Test debugging keymaps
	vim.keymap.set("n", "<leader>dtm", dap_python.test_method, { desc = "Debug: Test Method" })
	vim.keymap.set("n", "<leader>dtc", dap_python.test_class, { desc = "Debug: Test Class" })
	vim.keymap.set("n", "<leader>dts", function()
		dap_python.debug_selection()
	end, { desc = "Debug: Test Selection" })

	-- Neotest integration
	local neotest = require("neotest")
	vim.keymap.set("n", "<leader>td", function()
		neotest.run.run({ strategy = "dap" })
	end, { desc = "Debug: Current Test" })
end

return M
