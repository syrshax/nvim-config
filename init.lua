-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.python3_host_prog = vim.fn.exepath("python3")
vim.g.maplocalleader = " "
vim.opt["tabstop"] = 4
vim.opt["shiftwidth"] = 4
vim.opt.colorcolumn = "99"
vim.opt.signcolumn = "yes"

vim.api.nvim_create_autocmd("FileType", {
	desc = "Comprehensively reformat Python with Ruff",
	pattern = "python",
	callback = function()
		vim.keymap.set("n", "<leader>fF", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.fixAll" }, diagnostics = {} },
				apply = true,
			})
			vim.lsp.buf.format({ async = true })
		end, { desc = "Format buffer" })
	end,
})
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
--

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = "unnamedplus"

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
-- vim.opt.list = true
-- vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 25

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
-- Set highlight on search, but clear on pressing <Esc> in normal mode hgahjsdahsjdashd
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
-- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require("plugins/neo-tree")
vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle<CR>")
vim.keymap.set("n", "<Tab>", "gt")
require("lazy").setup(
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
		-- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
		"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
		"MunifTanjim/nui.nvim",
		{
			"rose-pine/neovim",
			name = "rose-pine",
			config = function()
				require("rose-pine").setup({
					variant = "auto", -- auto, main, moon, or dawn
					dark_variant = "main", -- main, moon, or dawn
					dim_inactive_windows = false,
					extend_background_behind_borders = true,

					enable = {
						terminal = true,
						legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
						migrations = true, -- Handle deprecated options automatically
					},

					styles = {
						bold = true,
						italic = true,
						transparency = false,
					},

					groups = {
						border = "muted",
						link = "iris",
						panel = "surface",

						error = "love",
						hint = "iris",
						info = "foam",
						note = "pine",
						todo = "rose",
						warn = "gold",

						git_add = "foam",
						git_change = "rose",
						git_delete = "love",
						git_dirty = "rose",
						git_ignore = "muted",
						git_merge = "iris",
						git_rename = "pine",
						git_stage = "iris",
						git_text = "rose",
						git_untracked = "subtle",

						h1 = "iris",
						h2 = "foam",
						h3 = "rose",
						h4 = "gold",
						h5 = "pine",
						h6 = "foam",
					},

					palette = {
						-- Override the builtin palette per variant
						-- moon = {
						--     base = '#18191a',
						--     overlay = '#363738',
						-- },
					},

					highlight_groups = {
						GitSignsCurrentLineBlame = { fg = "subtle", bg = "none" }, -- Add this line
						-- Comment = { fg = "foam" },
						-- VertSplit = { fg = "muted", bg = "muted" },
					},

					before_highlight = function(group, highlight, palette)
						-- Disable all undercurls
						-- if highlight.undercurl then
						--     highlight.undercurl = false
						-- end
						--
						-- Change palette colour
						-- if highlight.fg == palette.pine then
						--     highlight.fg = palette.foam
						-- end
					end,
				})
				-- vim.cmd("colorscheme rose-pine-main")
				-- vim.cmd("colorscheme rose-pine-moon")
				-- vim.cmd("colorscheme rose-pine-dawn")
			end,
		},
		{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
		"EdenEast/nightfox.nvim",
		"sainnhe/everforest",
		"ntk148v/komau.vim",
		"lunarvim/horizon.nvim",
		"zSnails/cityscape.nvim",
		{
			"nvim-neotest/neotest",
			dependencies = {
				"nvim-neotest/nvim-nio",
				"nvim-lua/plenary.nvim",
				"antoinemadec/FixCursorHold.nvim",
				"nvim-treesitter/nvim-treesitter",
				"nvim-neotest/neotest-python",
			},
			config = function()
				local neotest = require("neotest")
				-- Define custom signs with larger text
				local signs = {
					passed = {
						text = "✔",
						texthl = "NeotestPassed",
						numhl = "NeotestPassed",
					},
					failed = {
						text = "✗",
						texthl = "NeotestFailed",
						numhl = "NeotestFailed",
					},
					running = {
						text = "⟳",
						texthl = "NeotestRunning",
						numhl = "NeotestRunning",
					},
					skipped = {
						text = "○",
						texthl = "NeotestSkipped",
						numhl = "NeotestSkipped",
					},
				}
				-- Register the signs
				for name, sign in pairs(signs) do
					vim.fn.sign_define("neotest_" .. name, sign)
				end
				neotest.setup({
					adapters = {
						require("neotest-python")({
							runner = "pytest",
							args = { "--verbose" },
							python = function()
								if vim.fn.executable("poetry") == 1 then
									return vim.fn.trim(vim.fn.system("poetry env info -p")) .. "/bin/python"
								elseif vim.fn.executable("poe") == 1 then
									return vim.fn.expand("$VIRTUAL_ENV/bin/python")
								else
									return vim.fn.exepath("python3") or vim.fn.exepath("python")
								end
							end,
						}),
					},
					output = {
						enabled = true,
						open_on_run = true,
					},
					output_panel = {
						enabled = true, -- Disable the output panel by default
						open_on_run = false, -- Ensure it doesn't open on run
					},
					status = {
						enabled = true,
						virtual_text = true,
						signs = true,
					},
					summary = {
						enabled = true,
						expand_errors = true,
						follow = true,
						mappings = {
							expand = { "<CR>", "<2-LeftMouse>" },
							expand_all = "e",
							output = "o",
							short = "O",
							run = "r",
							run_marked = "R",
							clear_marked = "c",
							jumpto = "i",
							stop = "u",
							mark = "m",
							debug = "d",
						},
					},
					floating = {
						border = "rounded",
						max_height = 0.9,
						max_width = 0.7,
						options = {},
					},
					highlights = {
						passed = "String",
						failed = "DiagnosticError",
						running = "Special",
						skipped = "Comment",
					},
				})

				-- Modified function to use floating window instead of output panel
				local function show_test_output()
					vim.schedule(function()
						neotest.output.open({ enter = true, auto_close = true })
					end)
				end

				vim.keymap.set("n", "<leader>tt", function()
					neotest.run.run(vim.fn.expand("%"))
					show_test_output()
				end, { desc = "Run File" })

				vim.keymap.set("n", "<leader>tT", function()
					neotest.run.run(vim.loop.cwd())
					show_test_output()
				end, { desc = "Run All Test Files" })

				vim.keymap.set("n", "<leader>tr", function()
					neotest.run.run()
					show_test_output()
				end, { desc = "Run Nearest" })

				vim.keymap.set("n", "<leader>ts", function()
					neotest.summary.toggle()
				end, { desc = "Toggle Summary" })

				vim.keymap.set("n", "<leader>to", function()
					vim.schedule(function()
						neotest.output.open({ enter = true })
					end)
				end, { desc = "Show Output" })

				vim.keymap.set("n", "<leader>tO", function()
					neotest.output_panel.toggle()
				end, { desc = "Toggle Output Panel" })

				vim.keymap.set("n", "<leader>tS", function()
					neotest.run.stop()
				end, { desc = "Stop" })

				vim.keymap.set("n", "[t", function()
					neotest.jump.prev({ status = "failed" })
				end, { desc = "Previous Failed Test" })

				vim.keymap.set("n", "]t", function()
					neotest.jump.next({ status = "failed" })
				end, { desc = "Next Failed Test" })
			end,
		},
		{
			"rcarriga/nvim-dap-ui",
			dependencies = {
				"mfussenegger/nvim-dap",
				"mfussenegger/nvim-dap-python",
				"nvim-neotest/nvim-nio",
			},
			config = function()
				require("custom.dap").setup()
			end,
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			---@module "ibl"
			---@type ibl.config
			opts = {},
		},
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
				-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
			},
		},
		{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true, opts = ... },
		{ "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },
		-- NOTE: Plugins can also be added by using a table,
		-- with the first argument being the link and the following
		-- keys can be used to configure plugin behavior/loading/etc.
		--
		-- Use `opts = {}` to force a plugin to be loaded.
		--
		--  This is equivalent to:
		--    require('Comment').setup({})

		-- "gc" to comment visual regions/lines
		{ "numToStr/Comment.nvim", opts = {} },

		-- Here is a more advanced example where we pass configuration
		-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
		--    require('gitsigns').setup({ ... })
		--
		-- See `:help gitsigns` to understand what the configuration keys do
		{ -- Adds git related signs to the gutter, as well as utilities for managing changes
			"lewis6991/gitsigns.nvim",
			opts = {
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
				auto_attach = true,
				current_line_blame = true,
			},
		},

		-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
		--
		-- This is often very useful to both group configuration, as well as handle
		-- lazy loading plugins that don't need to be loaded immediately at startup.
		--
		-- For example, in the following configuration, we use:
		--  event = 'VimEnter'
		--
		-- which loads which-key before all the UI elements are loaded. Events can be
		-- normal autocommands events (`:help autocmd-events`).
		--
		-- Then, because we use the `config` key, the configuration only runs
		-- after the plugin has been loaded:
		--  config = function() ... end
		--

		{ -- Useful plugin to show you pending keybinds.
			"folke/which-key.nvim",
			event = "VimEnter", -- Sets the loading event to 'VimEnter'
			config = function() -- This is the function that runs, AFTER loading
				require("which-key").setup()

				-- Document existing key chains
				-- visual mode
			end,
		},

		-- NOTE: Plugins can specify dependencies.
		--
		-- The dependencies are proper plugin specifications as well - anything
		-- you do for a plugin at the top level, you can do for a dependency.
		--
		-- Use the `dependencies` key to specify the dependencies of a particular plugin

		{ -- Fuzzy Finder (files, lsp, etc)
			"nvim-telescope/telescope.nvim",
			event = "VimEnter",
			branch = "0.1.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				{ -- If encountering errors, see telescope-fzf-native README for installation instructions
					"nvim-telescope/telescope-fzf-native.nvim",

					-- `build` is used to run some command when the plugin is installed/updated.
					-- This is only run then, not every time Neovim starts up.
					build = "make",

					-- `cond` is a condition used to determine whether this plugin should be
					-- installed and loaded.
					cond = function()
						return vim.fn.executable("make") == 1
					end,
				},
				{ "nvim-telescope/telescope-ui-select.nvim" },

				-- Useful for getting pretty icons, but requires a Nerd Font.
				{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
			},
			config = function()
				-- Telescope is a fuzzy finder that comes with a lot of different things that
				-- it can fuzzy find! It's more than just a "file finder", it can search
				-- many different aspects of Neovim, your workspace, LSP, and more!
				--
				-- The easiest way to use Telescope, is to start by doing something like:
				--  :Telescope help_tags
				--
				-- After running this command, a window will open up and you're able to
				-- type in the prompt window. You'll see a list of `help_tags` options and
				-- a corresponding preview of the help.
				--
				-- Two important keymaps to use while in Telescope are:
				--  - Insert mode: <c-/>
				--  - Normal mode: ?
				--
				-- This opens a window that shows you all of the keymaps for the current
				-- Telescope picker. This is really useful to discover what Telescope can
				-- do as well as how to actually do it!

				-- [[ Configure Telescope ]]
				-- See `:help telescope` and `:help telescope.setup()`
				require("telescope").setup({
					-- You can put your default mappings / updates / etc. in here
					--  All the info you're looking for is in `:help telescope.setup()`
					--
					-- defaults = {
					--   mappings = {
					--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
					--   },
					-- },
					pickers = {
						colorscheme = {
							enable_preview = true,
						},
					},
					extensions = {
						["ui-select"] = {
							require("telescope.themes").get_dropdown(),
						},
					},
				})

				-- Enable Telescope extensions if they are installed
				pcall(require("telescope").load_extension, "fzf")
				pcall(require("telescope").load_extension, "ui-select")

				-- See `:help telescope.builtin`
				local builtin = require("telescope.builtin")
				vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
				vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
				vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
				vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
				vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
				vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
				vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
				vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
				vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
				vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

				-- Slightly advanced example of overriding default behavior and theme
				vim.keymap.set("n", "<leader>/", function()
					-- You can pass additional configuration to Telescope to change the theme, layout, etc.
					builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
						winblend = 10,
						previewer = false,
					}))
				end, { desc = "[/] Fuzzily search in current buffer" })

				-- It's also possible to pass additional configuration options.
				--  See `:help telescope.builtin.live_grep()` for information about particular keys
				vim.keymap.set("n", "<leader>s/", function()
					builtin.live_grep({
						grep_open_files = true,
						prompt_title = "Live Grep in Open Files",
					})
				end, { desc = "[S]earch [/] in Open Files" })

				-- Shortcut for searching your Neovim configuration files
				vim.keymap.set("n", "<leader>sn", function()
					builtin.find_files({ cwd = vim.fn.stdpath("config") })
				end, { desc = "[S]earch [N]eovim files" })
			end,
		},

		{ -- LSP Configuration & Plugins
			"neovim/nvim-lspconfig",
			dependencies = {
				-- Automatically install LSPs and related tools to stdpath for Neovim
				{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
				"williamboman/mason-lspconfig.nvim",
				"WhoIsSethDaniel/mason-tool-installer.nvim",

				-- Useful status updates for LSP.
				-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
				{ "j-hui/fidget.nvim", opts = {} },

				-- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
				--   u sed for completion, annotations and signatures of Neovim apis
				{ "folke/neodev.nvim", opts = {} },
			},
			config = function()
				-- Brief aside: **What is LSP?**
				--
				-- LSP is an initialism you've probably heard, but might not understand what it is.
				--
				-- LSP stands for Language Server Protocol. It's a protocol that helps editors
				-- and language tooling communicate in a standardized fashion.
				--
				-- In general, you have a "server" which is some tool built to understand a particular
				-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
				-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
				-- processes that communicate with some "client" - in this case, Neovim!
				--
				-- LSP provides Neovim with features like:
				--  - Go to definition
				--  - Find references
				--  - Autocompletion
				--  - Symbol Search
				--  - and more!
				--
				-- Thus, Language Servers are external tools that must be installed separately from
				-- Neovim. This is where `mason` and related plugins come into play.
				--
				-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
				-- and elegantly composed help section, `:help lsp-vs-treesitter`

				--  This function gets run when an LSP attaches to a particular buffer.
				--    That is to say, every time a new file is opened that is associated with
				--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
				--    function will be executed to configure the current buffer
				vim.api.nvim_create_autocmd("LspAttach", {
					group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
					callback = function(event)
						-- NOTE: Remember that Lua is a real programming language, and as such it is possible
						-- to define small helper and utility functions so you don't have to repeat yourself.
						--
						-- In this case, we create a function that lets us more easily define mappings specific
						-- for LSP related items. It sets the mode, buffer and description for us each time.
						local map = function(keys, func, desc)
							vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
						end

						-- Jump to the definition of the word under your cursor.
						--  This is where a variable was first declared, or where a function is defined, etc.
						--  To jump back, press <C-t>.
						map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

						-- Find references for the word under your cursor.
						map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

						-- Jump to the implementation of the word under your cursor.
						--  Useful when your language has ways of declaring types without an actual implementation.
						map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

						-- Jump to the type of the word under your cursor.
						--  Useful when you're not sure what type a variable is and you want to see
						--  the definition of its *type*, not where it was *defined*.
						map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

						-- Fuzzy find all the symbols in your current document.
						--  Symbols are things like variables, functions, types, etc.
						map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

						-- Fuzzy find all the symbols in your current workspace.
						--  Similar to document symbols, except searches over your entire project.
						map(
							"<leader>ws",
							require("telescope.builtin").lsp_dynamic_workspace_symbols,
							"[W]orkspace [S]ymbols"
						)

						-- Rename the variable under your cursor.
						--  Most Language Servers support renaming across files, etc.
						map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

						-- Execute a code action, usually your cursor needs to be on top of an error
						-- or a suggestion from your LSP for this to activate.
						map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

						-- Opens a popup that displays documentation about the word under your cursor
						--  See `:help K` for why this keymap.
						map("K", vim.lsp.buf.hover, "Hover Documentation")

						-- WARN: This is not Goto Definition, this is Goto Declaration.
						--  For example, in C this would take you to the header.
						map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

						-- The following two autocommands are used to highlight references of the
						-- word under your cursor when your cursor rests there for a little while.
						--    See `:help CursorHold` for information about when this is executed
						--
						-- When you move your cursor, the highlights will be cleared (the second autocommand).
						local client = vim.lsp.get_client_by_id(event.data.client_id)
						if client and client.server_capabilities.documentHighlightProvider then
							local highlight_augroup =
								vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
							vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
								buffer = event.buf,
								group = highlight_augroup,
								callback = vim.lsp.buf.document_highlight,
							})

							vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
								buffer = event.buf,
								group = highlight_augroup,
								callback = vim.lsp.buf.clear_references,
							})
						end

						-- The following autocommand is used to enable inlay hints in your
						-- code, if the language server you are using supports them
						--
						-- This may be unwanted, since they displace some of your code
						if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
							map("<leader>th", function()
								vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
							end, "[T]oggle Inlay [H]ints")
						end
					end,
				})

				vim.api.nvim_create_autocmd("LspDetach", {
					group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
					callback = function(event)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event.buf })
					end,
				})

				-- LSP servers and clients are able to communicate to each other what features they support.
				--  By default, Neovim doesn't support everything that is in the LSP specification.
				--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
				--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities =
					vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

				-- Enable the following language servers
				--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
				--
				--  Add any additional override configuration in the following tables. Available keys are:
				--  - cmd (table): Override the default command used to start the server
				--  - filetypes (table): Override the default list of associated filetypes for the server
				--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
				--  - settings (table): Override the default settings passed when initializing the server.
				--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
				local servers = {
					pyright = {
						settings = {
							pyright = {
								autoImportCompletion = true,
								-- Add these settings for better import discovery
								disableOrganizeImports = false,
							},
							python = {
								analysis = {
									autoSearchPaths = true,
									diagnosticMode = "workspace", -- Changed from 'openFilesOnly' to analyze the whole workspace
									useLibraryCodeForTypes = true,
									typeCheckingMode = "off",
									-- Add these settings for better completion and analysis
									indexing = true,
									inlayHints = {
										variableTypes = true,
										functionReturnTypes = true,
									},
									-- Enhance auto-import and completion features
									importFormat = "absolute",
									stubPath = "typings",
									extraPaths = {}, -- Add any additional paths you want Pyright to search
									diagnosticSeverityOverrides = {
										reportMissingImports = "none", -- Adjust if you want to see missing imports
										reportMissingModuleSource = "none",
									},
									-- Improve workspace symbol finding
									workspaceSymbols = true,
									-- Complete all members
									completeFunctionParens = true,
								},
							},
						},
						-- Add custom file watching pattern if needed
						filetypes = { "python" },
						flags = {
							debounce_text_changes = 150,
						},
						-- Add root_dir configuration to help Pyright find your project root
						root_dir = function(fname)
							local util = require("lspconfig.util")
							-- Detect root directory by looking for common Python project files
							return util.root_pattern(
								"pyproject.toml",
								"setup.py",
								"setup.cfg",
								"requirements.txt",
								"Pipfile",
								"pyrightconfig.json"
							)(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
						end,
					},
					-- Your other LSP servers configuration...
					lua_ls = {
						settings = {
							Lua = {
								completion = {
									callSnippet = "Replace",
								},
							},
						},
					},
				}

				-- Ensure the servers and tools above are installed
				--  To check the current status of installed tools and/or manually install
				--  other tools, you can run
				--    :Mason
				--
				--  You can press `g?` for help in this menu.
				require("mason").setup()

				-- You can add other tools here that you want Mason to install
				-- for you, so that they are available from within Neovim.
				local ensure_installed = vim.tbl_keys(servers or {})
				vim.list_extend(ensure_installed, {
					"stylua", -- Used to format Lua code
				})
				require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

				require("mason-lspconfig").setup({
					handlers = {
						function(server_name)
							local server = servers[server_name] or {}
							server.capabilities =
								vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
							require("lspconfig")[server_name].setup(server)
						end,
					},
				})
			end,
		},

		{ -- Autoformat
			"stevearc/conform.nvim",
			lazy = false,
			keys = {
				{
					"<leader>f",
					function()
						require("conform").format({ async = true, lsp_fallback = true })
					end,
					mode = "",
					desc = "[F]ormat buffer",
				},
			},
			opts = {
				notify_on_error = false,
				format_on_save = function(bufnr)
					-- Disable "format_on_save lsp_fallback" for languages that don't
					-- have a well standardized coding style. You can add additional
					-- languages here or re-enable it for the disabled ones.
					local disable_filetypes = { c = true, cpp = true }
					return {
						timeout_ms = 500,
						lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
					}
				end,
				formatters_by_ft = {
					lua = { "stylua" },
					-- Conform can also run multiple formatters sequentially
					-- python = { "isort", "black" },
					--
					-- You can use a sub-list to tell conform to run *until* a formatter
					-- is found.
					-- javascript = { { "prettierd", "prettier" } },
				},
			},
		},

		{ -- Autocompletion
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			dependencies = {
				-- Snippet Engine & its associated nvim-cmp source
				{
					"L3MON4D3/LuaSnip",
					build = (function()
						-- Build Step is needed for regex support in snippets.
						-- This step is not supported in many windows environments.
						-- Remove the below condition to re-enable on windows.
						if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
							return
						end
						return "make install_jsregexp"
					end)(),
					dependencies = {
						-- `friendly-snippets` contains a variety of premade snippets.
						--    See the README about individual language/framework/plugin snippets:
						--    https://github.com/rafamadriz/friendly-snippets
						-- {
						--   'rafamadriz/friendly-snippets',
						--   config = function()
						--     require('luasnip.loaders.from_vscode').lazy_load()
						--   end,
						-- },
					},
				},
				"saadparwaiz1/cmp_luasnip",

				-- Adds other completion capabilities.
				--  nvim-cmp does not ship with all sources by default. They are split
				--  into multiple repos for maintenance purposes.
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
			},
			config = function()
				-- See `:help cmp`
				local cmp = require("cmp")
				local luasnip = require("luasnip")
				luasnip.config.setup({})

				cmp.setup({
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					completion = { completeopt = "menu,menuone,noinsert" },

					-- For an understanding of why these mappings were
					-- chosen, you will need to read `:help ins-completion`
					--
					-- No, but seriously. Please read `:help ins-completion`, it is really good!
					mapping = cmp.mapping.preset.insert({
						-- Select the [n]ext item
						["<C-n>"] = cmp.mapping.select_next_item(),
						-- Select the [p]revious item
						["<C-p>"] = cmp.mapping.select_prev_item(),

						-- Scroll the documentation window [b]ack / [f]orward
						["<C-b>"] = cmp.mapping.scroll_docs(-4),
						["<C-f>"] = cmp.mapping.scroll_docs(4),

						-- Accept ([y]es) the completion.
						--  This will auto-import if your LSP supports it.
						--  This will expand snippets if the LSP sent a snippet.
						["<C-y>"] = cmp.mapping.confirm({ select = true }),

						-- If you prefer more traditional completion keymaps,
						-- you can uncomment the following lines
						--['<CR>'] = cmp.mapping.confirm { select = true },
						--['<Tab>'] = cmp.mapping.select_next_item(),
						--['<S-Tab>'] = cmp.mapping.select_prev_item(),

						-- Manually trigger a completion from nvim-cmp.
						--  Generally you don't need this, because nvim-cmp will display
						--  completions whenever it has completion options available.
						["<C-Space>"] = cmp.mapping.complete({}),

						-- Think of <c-l> as moving to the right of your snippet expansion.
						--  So if you have a snippet that's like:
						--  function $name($args)
						--    $body
						--  end
						--
						-- <c-l> will move you to the right of each of the expansion locations.
						-- <c-h> is similar, except moving you backwards.
						["<C-l>"] = cmp.mapping(function()
							if luasnip.expand_or_locally_jumpable() then
								luasnip.expand_or_jump()
							end
						end, { "i", "s" }),
						["<C-h>"] = cmp.mapping(function()
							if luasnip.locally_jumpable(-1) then
								luasnip.jump(-1)
							end
						end, { "i", "s" }),

						-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
						--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
					}),
					sources = {
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
						{ name = "path" },
					},
				})
			end,
		},

		{ -- You can easily change to a different colorscheme.
			-- Change the name of the colorscheme plugin below, and then
			-- change the command in the config to whatever the name of that colorscheme is.
			--
			-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
			"folke/tokyonight.nvim",
			priority = 1000, -- Make sure to load this before all the other start plugins.
			init = function()
				-- Load the colorscheme here.
				-- Like many other themes, this one has different styles, and you could load
				-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
				vim.cmd.colorscheme("gruvbox")
				vim.o.background = "light"
				-- You can configure highlights by doing something like:
				vim.cmd.hi("Comment gui=bold,italic") -- Both bold and italic
			end,
		},
		-- Highlight todo, notes, etc in comments
		{
			"folke/todo-comments.nvim",
			event = "VimEnter",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = { signs = false },
		},

		{ -- Collection of various small independent plugins/modules
			"echasnovski/mini.nvim",
			config = function()
				-- Better Around/Inside textobjects
				--
				-- Examples:
				--  - va)  - [V]isually select [A]round [)]paren
				--  - yinq - [Y]ank [I]nside [N]ext [']quote
				--  - ci'  - [C]hange [I]nside [']quote
				require("mini.ai").setup({ n_lines = 500 })

				-- Add/delete/replace surroundings (brackets, quotes, etc.)
				--
				-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
				-- - sd'   - [S]urround [D]elete [']quotes
				-- - sr)'  - [S]urround [R]eplace [)] [']
				require("mini.surround").setup()

				-- Simple and easy statusline.
				--  You could remove this setup call if you don't like it,
				--  and try some other statusline plugin
				local statusline = require("mini.statusline")
				-- set use_icons to true if you have a Nerd Font
				statusline.setup({ use_icons = vim.g.have_nerd_font })

				-- You can configure sections in the statusline by overriding their
				-- default behavior. For example, here we set the section for
				-- cursor location to LINE:COLUMN
				---@diagnostic disable-next-line: duplicate-set-field
				statusline.section_location = function()
					return "%2l:%-2v"
				end

				-- ... and there is more!
				--  Check out: https://github.com/echasnovski/mini.nvim
			end,
		},
		{ -- Highlight, edit, and navigate code
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			opts = {
				ensure_installed = { "bash", "c", "html", "lua", "luadoc", "markdown", "vim", "vimdoc", "python" },
				-- Autoinstall languages that are not installed
				auto_install = true,
				highlight = {
					enable = true,
					-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
					--  If you are experiencing weird indenting issues, add the language to
					--  the list of additional_vim_regex_highlighting and disabled languages for indent.
					additional_vim_regex_highlighting = { "ruby" },
				},
				indent = { enable = true, disable = { "ruby" } },
			},
			config = function(_, opts)
				-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

				-- Prefer git instead of curl in order to improve connectivity in some environments
				require("nvim-treesitter.install").prefer_git = true
				---@diagnostic disable-next-line: missing-fields
				require("nvim-treesitter.configs").setup(opts)

				-- There are additional nvim-treesitter modules that you can use to interact
				-- with nvim-treesitter. You should go explore a few and see what interests you:
				--
				--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
				--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
				--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
			end,
		},
		{
			"kdheepak/lazygit.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			config = function()
				-- Configuration for lazygit.nvim
				vim.g.lazygit_floating_window_winblend = 0 -- transparency of floating window
				vim.g.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
				vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } -- customize lazygit popup window border characters
				vim.g.lazygit_use_neovim_remote = 1 -- fallback to 0 if neovim-remote is not installed

				-- Key mappings for LazyGit
				vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { silent = true, desc = "Open LazyGit" })
				-- Open LazyGit in current file's directory
				vim.keymap.set(
					"n",
					"<leader>gf",
					":LazyGitCurrentFile<CR>",
					{ silent = true, desc = "LazyGit Current File" }
				)
				-- Show Git file history
				vim.keymap.set(
					"n",
					"<leader>gh",
					":LazyGitFilter<CR>",
					{ silent = true, desc = "LazyGit File History" }
				)
				-- Show Git commits of current file
				vim.keymap.set(
					"n",
					"<leader>gc",
					":LazyGitFilterCurrentFile<CR>",
					{ silent = true, desc = "LazyGit Current File History" }
				)
			end,
		},
	},

	-- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
	-- init.lua. If you want these files, they are in the repository, so you can just download them and
	-- place them in the correct locations.

	-- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
	--
	--  Here are some example plugins that I've included in the Kickstart repository.
	--  Uncomment any of the lines below to enable them (you will need to restart nvim).
	--
	-- require 'kickstart.plugins.debug',
	-- require 'kickstart.plugins.indent_line',
	-- require 'kickstart.plugins.lint',
	-- require 'kickstart.plugins.autopairs',
	-- require 'kickstart.plugins.neo-tree',
	-- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

	-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	--    This is the easiest way to modularize your config.
	--
	--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
	--    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
	-- { import = 'custom.plugins' },
	{
		ui = {
			-- If you are using a Nerd Font: set icons to an empty table which will use the
			-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
			icons = vim.g.have_nerd_font and {} or {
				cmd = "⌘",
				config = "🛠",
				event = "📅",
				ft = "📂",
				init = "⚙",
				keys = "🗝",
				plugin = "🔌",
				runtime = "💻",
				require = "🌙",
				source = "📄",
				start = "🚀",
				task = "📌",
				lazy = "💤 ",
			},
		},
	}
)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
