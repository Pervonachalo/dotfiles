return {
	{
		"saghen/blink.cmp",
		version = "*",
		dependencies = "rafamadriz/friendly-snippets",

		opts = {
			-- keymap = {
			-- preset = "default",
			-- ["<Tab>"] = { "snippet_forward", "fallback" },
			-- ["<S-Tab>"] = { "snippet_backward", "fallback" },
			-- ["<CR>"] = { "accept", "fallback" },
			-- },

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					path = {
						opts = {
							-- Активирует отображение скрытых файлов по умолчанию
							show_hidden_files_by_default = true,
						},
					},
				},
			},

			-- Настройка поведения списка
			completion = {
				documentation = {
					auto_show = true,
					window = { border = "rounded" },
				},
				list = {
					selection = {
						preselect = false, -- Не выбирать первый элемент автоматически
						auto_insert = false, -- Не вставлять текст, пока не нажмете подтверждение
						-- auto_insert = true,
					},
				},
				menu = { border = "rounded" },
			},

			cmdline = {
				enabled = true,
				completion = {
					menu = { auto_show = true },
					list = {
						selection = {
							preselect = false, -- Не подсвечивать первый элемент сразу
							auto_insert = false, -- НЕ вставлять текст в строку, пока вы сами не выберете его
							-- auto_insert = true,
						},
					},
				},
				-- keymap = {
				-- ["<Tab>"] = { "select_next", "fallback" },
				-- ["<S-Tab>"] = { "select_prev", "fallback" },
				-- ["<CR>"] = { "accept", "fallback" },
				-- },

				sources = function()
					local type = vim.fn.getcmdtype()
					-- Поиск в буфере
					if type == "/" or type == "?" then
						return { "buffer" }
					end

					-- Командная строка (включая Noice)
					if type == ":" then
						return { "cmdline", "path" }
					end -- Добавляем "path" сюда
					return {}
				end,
			},

			signature = { enabled = true, window = { border = "rounded" } },
		},
	},
}
