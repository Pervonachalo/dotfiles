return {
	-- 1. Telescope с фиксом для Neovim 0.11.4
	{
		"nvim-telescope/telescope.nvim",
		-- tag = "0.1.8",
		branch = "0.1.x", -- Используйте tag или branch, 0.1.8 стабилен для 2026 года
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-tree/nvim-web-devicons", enabled = true },
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local telescope = require("telescope")

			-- Патч совместимости для Neovim 0.11+
			if vim.treesitter.language.ft_to_lang == nil then
				vim.treesitter.language.ft_to_lang = function(ft)
					return vim.treesitter.language.get_lang(ft) or ft
				end
			end

			telescope.setup({
				defaults = {
					-- чтобы окно предпросмотра кода было чуть шире и информативнее.
					layout_config = { horizontal = { preview_width = 0.55 } },

					-- Оптимизация отображения путей
					-- path_display = { "smart" },
					path_display = { "filename_first" }, -- Сначала имя файла, Путь в конце, или "smart"

					preview = { treesitter = false },
					mappings = {
						i = {
							["<C-k>"] = "move_selection_previous",
							["<C-j>"] = "move_selection_next",
							-- Настраиваем открытие Diffview по Ctrl+o в режиме вставки
							["<C-o>"] = function(prompt_bufnr)
								local selection = require("telescope.actions.state").get_selected_entry()
								require("telescope.actions").close(prompt_bufnr)
								vim.cmd("DiffviewOpen " .. selection.value .. "^!")
							end,
						},
						n = {
							-- То же самое для нормального режима (если нужно)
							["<C-o>"] = function(prompt_bufnr)
								local selection = require("telescope.actions.state").get_selected_entry()
								require("telescope.actions").close(prompt_bufnr)
								vim.cmd("DiffviewOpen " .. selection.value .. "^!")
							end,
						},
					},
				},
				pickers = {
					find_files = {
						-- Параметр для поиска по скрытым файлам (например, .env)
						hidden = true, -- Показывать скрытые файлы
						-- Не искать в .git и node_modules
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
						-- theme = "dropdown",
					},

					grep_string = {
						additional_args = function()
							return { "--hidden" }
						end,
					},

					live_grep = {
						-- ПРАВИЛЬНЫЙ синтаксис передачи аргументов для ripgrep
						additional_args = function()
							return { "--hidden" } -- Правильный формат передачи аргументов rg
						end,
					},
				},
				extensions = {
					-- ...
				},
			})
			-- Загрузка расширений (если установлены)
			-- Включаем ускорение поиска fzf, если плагин скомпилировался
			pcall(telescope.load_extension, "fzf")

			-- Keymaps (using local variables for clarity)
			local map = vim.keymap.set
			local builtin = require("telescope.builtin")

			-- Search / Find files
			map("n", "<leader>ff", builtin.find_files, { desc = "Telescope: Find files" })
			map("n", "<leader>fg", builtin.live_grep, { desc = "Telescope: Live grep" })
			map("n", "<leader>fb", builtin.buffers, { desc = "Telescope: Buffers" })
			map("n", "<leader>fh", builtin.help_tags, { desc = "Telescope: Help tags" })

			-- Git integration
			map("n", "<leader>gb", builtin.git_branches, { desc = "Telescope: Git branches" })
			map("n", "<leader>gh", builtin.git_commits, { desc = "Telescope: Git commits (History)" })
			-- map("n", "<leader>gs", builtin.git_status, { desc = "Telescope: Git status" })
			map("n", "<leader>gf", builtin.git_files, { desc = "Search Git Files" })

			-- LSP integration (Visual UI for references and symbols)
			map("n", "<leader>ls", builtin.lsp_document_symbols, { desc = "Telescope: LSP Document symbols" })
			map("n", "gr", builtin.lsp_references, { desc = "Telescope: LSP Go to references" })

			-- Reminder: 'gd' is handled natively in nvim-lspconfig.lua to avoid deprecation warnings
		end,
	},

	-- 2. Treesitter (ветка master)
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",

		config = function()
			require("nvim-treesitter.configs").setup({
				-- Автоматическая установка парсеров
				ensure_installed = {
					"asm",
					"bash",
					"c",
					"cmake",
					"commonlisp",
					"cpp",
					"css",
					"cue",
					"diff",
					"dockerfile",
					"gitcommit",
					"gitignore",
					"html",
					"ini",
					"javascript",
					"jsdoc",
					"json",
					"jsonc",
					"lua",
					"luadoc",
					"luap",
					"make",
					"markdown",
					"markdown_inline",
					"muttrc",
					"pascal",
					"perl",
					"po",
					"printf",
					"prolog",
					"python",
					"query",
					"regex",
					"rust",
					"scheme",
					"sql",
					"ssh_config",
					"tcl",
					"toml",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
					"xml",
					"xresources",
					"yaml",
					"zathurarc",
				},

				-- Рекомендуется false для стабильности, чтобы установка шла в фоне
				sync_install = false,
				-- Автоматическая установка отсутствующих парсеров
				auto_install = true,
				ignore_install = {},

				highlight = {
					enable = true,
					-- Отключено для улучшения производительности
					additional_vim_regex_highlighting = false,
				},

				-- Дополнительный модуль для улучшения работы с отступами
				indent = {
					enable = true,
				},

				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
			})
		end,
	},

	-- 3. Neogit (Умная логика для Bare-репозитория и обычных проектов)

	{
		"NeogitOrg/neogit",
		dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
		cmd = "Neogit",
		keys = {
			-- Умный статус (оставляем как есть, там всё верно)
			{
				"<leader>gs",
				function()
					local home = vim.fn.expand("$HOME")
					if vim.fn.getcwd() == home then
						vim.env.GIT_DIR = home .. "/.cfg/"
						vim.env.GIT_WORK_TREE = home
						require("neogit").open({ cwd = home, kind = "tab" })
						vim.api.nvim_create_autocmd("BufUnload", {
							pattern = "NeogitStatus",
							once = true,
							callback = function()
								vim.env.GIT_DIR = nil
								vim.env.GIT_WORK_TREE = nil
							end,
						})
					else
						require("neogit").open({ kind = "tab" })
					end
				end,
				desc = "Neogit: Git Status",
			},
			-- ПРИНУДИТЕЛЬНЫЙ ВХОД (теперь тоже с очисткой)
			{
				"<leader>gc",
				function()
					local home = vim.fn.expand("$HOME")
					vim.env.GIT_DIR = home .. "/.cfg/"
					vim.env.GIT_WORK_TREE = home
					require("neogit").open({ cwd = home, kind = "tab" })
					-- ДОБАВЛЕНО: очистка, чтобы не портить работу в других проектах
					vim.api.nvim_create_autocmd("BufUnload", {
						pattern = "NeogitStatus",
						once = true,
						callback = function()
							vim.env.GIT_DIR = nil
							vim.env.GIT_WORK_TREE = nil
						end,
					})
				end,
				desc = "Neogit: Git Dotfiles",
			},
			-- Универсальный Push (всё верно)
			{
				"<leader>gp",
				function()
					local cmd
					if vim.env.GIT_DIR then
						cmd = "git --git-dir="
							.. vim.env.GIT_DIR
							.. " --work-tree="
							.. vim.env.GIT_WORK_TREE
							.. " push origin main"
					else
						cmd = "git push"
					end
					vim.notify("Pushing...", vim.log.levels.INFO)
					local output = vim.fn.system(cmd)
					if vim.v.shell_error == 0 then
						vim.notify("Push successful!", vim.log.levels.INFO)
						pcall(function()
							require("neogit").refresh()
						end)
					else
						vim.notify("Push failed: " .. output, vim.log.levels.ERROR)
					end
				end,
				desc = "Neogit: Git Push",
			},
		},
		opts = {
			disable_insert_on_commit = true,
			integrations = { diffview = true },
			status = { show_untracked_files = "no" },
		},
	},

	-- 4. Вспомогательные плагины
	{ "lewis6991/gitsigns.nvim", config = true },
	{ "s1n7ax/nvim-window-picker", name = "window-picker", config = true },
	{
		-- "echasnovski/mini.nvim",
		"nvim-mini/mini.nvim",
		version = "*",
		config = function()
			require("mini.pairs").setup({})
		end,
	},

	-- 5. obsidian.nvim
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*",
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"saghen/blink.cmp",
		},

		opts = {
			legacy_commands = false,

			workspaces = {
				{
					name = "notes",
					path = "~/Ins/Obsidian/Notebooks/Notes",
				},
			},

			completion = {
				nvim_cmp = false,
				min_chars = 2,
			},

			ui = {
				enable = true,
				update_debounce = 200,
			},

			checkboxes = {
				[" "] = { char = "  ", hl_group = "ObsidianTodo" },
				["x"] = { char = "", hl_group = "ObsidianDone" },
			},
			checkbox_order = { " ", "x" },
		},
		config = function(_, opts)
			vim.opt_local.conceallevel = 2

			require("obsidian").setup(opts)

			local keymap = vim.keymap.set

			keymap("n", "<leader>os", "<cmd>Obsidian search<CR>", { desc = "Поиск" })
			keymap("n", "<leader>on", "<cmd>Obsidian new<CR>", { desc = "Новая заметка" })
			keymap("n", "<leader>ob", "<cmd>Obsidian backlinks<CR>", { desc = "Обратные ссылки" })

			keymap("n", "gf", function()
				-- pcall мягко пробует выполнить команду, если она не сработает (не ссылка) - делает обычный gf
				local status, _ = pcall(vim.cmd, "Obsidian follow_link")
				if not status then
					return "gf"
				end
				return "" -- возвращаем пустую строку, так как команда уже выполнена
			end, { noremap = false, expr = true })
		end,
	},
}
