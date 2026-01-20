return {
	--  Тема OneDark
	{
		"navarasu/onedark.nvim",
		lazy = false, -- ВАЖНО: тема должна загружаться при старте
		priority = 1000, -- ВАЖНО: загрузить раньше других плагинов
		config = function()
			require("onedark").setup({
				style = "darker",
				code_style = {
					-- Change code style ---
					-- Options are italic, bold, underline, none
					-- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
					-- comments = 'italic',
					comments = "none",
					keywords = "none",
					functions = "none",
					strings = "none",
					variables = "none",
				},
				-- Lualine options --
				lualine = {
					-- transparent = false, -- lualine center bar transparency
					transparent = true, -- lualine center bar transparency
				},

				-- toggle theme style ---
				toggle_style_key = "<leader>ts", -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
				toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between
			})
			require("onedark").load()

			local wk = require("which-key")
			wk.add({
				{ "<leader>ts", desc = "OneDark: toggle theme style" },
			})
		end,
	},

	--  Иконки
	{ "nvim-tree/nvim-web-devicons", lazy = false },

	--  Neo-tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
		opts = {
			enable_git_status = true,
			filesystem = {
				filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = false },
				follow_current_file = { enabled = true },
			},
			event_handlers = {
				{
					event = "neo_tree_buffer_enter",
					handler = function()
						vim.cmd("highlight! link NeoTreeDotfile NeoTreeFileName")
						vim.cmd("highlight! link NeoTreeDotfileIcon NeoTreeFileIcon")
					end,
				},
			},
		},
	},

	--  Lualine
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "linrongbin16/lsp-progress.nvim" },
		config = function()
			-- 1. Инициализация lsp-progress (обязательно перед lualine)
			require("lsp-progress").setup({
				client_format = function(client_name, spinner, series_messages)
					if #series_messages == 0 then
						return nil
					end
					return " [" .. client_name .. "] " .. spinner .. " " .. table.concat(series_messages, ", ")
				end,
			})

			-- 2. Функция сбора информации об активных инструментах (LSP, Форматтеры, Линтеры)
			local function get_active_tools()
				local bufnr = vim.api.nvim_get_current_buf()
				local buf_ft = vim.bo.filetype
				local tools = {}

				-- Сбор активных LSP (  )
				local clients = vim.lsp.get_clients({ bufnr = bufnr })
				for _, client in ipairs(clients) do
					table.insert(tools, " " .. client.name)
				end

				-- Сбор форматтеров Conform (  )
				local conform_ok, conform = pcall(require, "conform")
				if conform_ok then
					local formatters = conform.list_formatters(bufnr)
					for _, fmt in ipairs(formatters) do
						table.insert(tools, "󰉡 " .. fmt.name)
					end
				end

				-- Сбор линтеров nvim-lint (  )
				local lint_ok, lint = pcall(require, "lint")
				if lint_ok then
					local linters = lint.linters_by_ft[buf_ft] or {}
					if type(linters) == "table" then
						for _, lint_name in ipairs(linters) do
							table.insert(tools, " " .. lint_name)
						end
					elseif type(linters) == "string" then
						table.insert(tools, " " .. linters)
					end
				end

				if #tools == 0 then
					return "No Tools"
				end
				-- return table.concat(tools, "  ")
				return table.concat(tools, " | ")
			end

			-- 3. Настройка Lualine
			-- Создаем группу подсветки для разделителей
			vim.api.nvim_set_hl(0, "LualineGreenSep", {
				fg = "#98c379",
				-- bg = "#282c34",
			})

			require("lualine").setup({
				options = {
					theme = "onedark",
					globalstatus = true, -- Единая статусная строка для всех окон
					-- component_separators = { left = "|", right = "|" },
					component_separators = {
						left = "%#LualineGreenSep#|",
						right = "%#LualineGreenSep#|",
					},
					section_separators = { left = "", right = "" },
					-- component_separators = { left = "", right = "" },
					-- section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = { "dashboard", "alpha", "starter", "TelescopePrompt", "ministarter" },
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = {
						{ "branch", icon = "", color = { fg = "#98c379" } },
						{ "diff", symbols = { added = " ", modified = " ", removed = " " } },
						{ "diagnostics" },
					},
					lualine_c = {
						{
							"filename",
							path = 1,
							symbols = { modified = "+", readonly = "=" },
							color = { fg = "#98c379" },
						},
						{
							-- Компонент прогресса LSP
							function()
								return require("lsp-progress").progress()
							end,
							-- color = { fg = "#e5c07b" },
							color = { fg = "#56b6c2" },
						},
					},
					lualine_x = {
						-- Компонент списка инструментов (LSP | Formatter | Linter)
						{
							get_active_tools,
							color = { fg = "#98c379" },
						},
						{
							"encoding",
							color = { fg = "#98c379" },
						},
						{
							"fileformat",
							color = { fg = "#98c379" },
						},
						{
							"filetype",
							color = { fg = "#98c379" },
						},
					},
					lualine_y = {
						{
							"progress",
							color = { fg = "#98c379" },
						},
					},
					lualine_z = { "location" },
				},
			})

			-- 4. Автоматическое обновление lualine при изменениях в LSP
			vim.api.nvim_create_autocmd("User", {
				pattern = "LspProgressStatusUpdated",
				callback = function()
					require("lualine").refresh()
				end,
			})
		end,
	},

	--  Bufferline

	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			options = {
				mode = "buffers",
				separator_style = "slant", -- Красивые наклонные разделители
				-- separator_style = "slope",
				diagnostics = "nvim_lsp", -- Показывать значки ошибок прямо на вкладках
				show_buffer_close_icons = false,
				show_close_icon = false,
				-- Это заставит вкладки не прыгать при открытии проводника
				offsets = {
					{
						filetype = "neo-tree",
						text = "File Explorer",
						text_align = "left",
						separator = true,
					},
				},
			},
		},
	},

	--  Which-key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = { preset = "modern", delay = 300 },
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		config = function()
			require("colorizer").setup({
				filetypes = { "*" },
				user_default_options = { names = true, mode = "background", tailwind = true },
			})
		end,
	},

	--  Indent Blankline
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = {
				char = "▏",
				tab_char = "▏",
			},
			scope = {
				enabled = true,
				show_start = false,
				show_end = false,
			},
		},
	},

	{
		--  Snacks (как бэкенд для уведомлений)
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			notifier = {
				enabled = true,
				timeout = 9000,
				-- icons = {
				-- 	error = " ",
				-- 	warn = " ",
				-- 	info = " ",
				-- 	debug = " ",
				-- 	trace = " ",
				-- },
				-- style = "fancy",
				-- Оставляем текстовую иконку для надежности в st
				-- icons = {
				-- 	error = "X ",
				-- 	warn = "! ",
				-- 	info = "i ",
				-- 	debug = "d ",
				-- 	trace = "t ",
				-- },
			},

			picker = {
				enabled = true,
				ui_select = true, -- Это заставит Mason использовать Snacks для поиска
			},
		},

		keys = {
			-- Посмотреть историю уведомлений
			{
				"<leader>nh",
				function()
					require("snacks").notifier.show_history()
				end,
				desc = "История уведомлений",
			},
			-- Закрыть все текущие уведомления (полезно, если их вылезло много)
			{
				"<leader>nd",
				function()
					require("snacks").notifier.hide()
				end,
				desc = "Скрыть уведомления",
			},
		},
	},

	{
		--  Noice (как интерфейс команд и прогресса)
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		opts = {
			-- Настройка уведомлений
			notify = {
				-- Если установлено в false, Noice будет использовать стандартный vim.notify,
				-- который уже перехвачен плагином Snacks.
				enabled = false,
			},
			lsp = {
				-- Интеграция с LSP (сигнатуры и документация в окнах)
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.set_formatting_string_config"] = true,
				},
				-- Мы отключаем прогресс в Noice, так как у вас есть fidget.nvim
				progress = { enabled = false },
			},
			presets = {
				bottom_search = true, -- поиск внизу, чтобы не прыгал экран
				command_palette = true, -- красивая панель команд по центру
				long_message_to_split = true, -- длинные сообщения в отдельном окне
			},
			routes = {
				-- Пример маршрута: перенаправлять все уведомления в Snacks
				{
					filter = { event = "notify" },
					view = "notify", -- В Noice это стандартное вью, которое использует vim.notify
				},
			},
		},
	},
}
