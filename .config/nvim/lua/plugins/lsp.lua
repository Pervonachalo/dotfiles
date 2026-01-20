return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		lazy = false,
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"Saghen/blink.cmp",
			"j-hui/fidget.nvim",
			"antosha417/nvim-lsp-file-operations",
		},

		config = function()
			local lspconfig = require("lspconfig")
			local mason_tool_installer = require("mason-tool-installer")
			local mason_lspconfig = require("mason-lspconfig")

			require("mason").setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "✓ ",
						package_pending = "➜ ",
						package_uninstalled = "✗ ",
					},
				},
				PATH = "prepend",
			})

			local servers = {
				awk_ls = {},
				bashls = {},
				bsl_ls = {},
				clangd = {
					-- Только специфичные для сервера вещи, например кодировка
					cmd = {
						"clangd",
						"--offset-encoding=utf-16",
						"--clang-tidy",
						"--background-index",
						"--header-insertion=iwyu",
						"--completion-style=detailed",
					},
				},
				cmake = {},
				cssls = {},
				docker_compose_language_service = {},
				dockerls = {},
				html = {},
				jsonls = {},
				lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim" } } } } },
				marksman = {},
				mutt_ls = {},
				perlnavigator = {},
				pyright = {},
				rust_analyzer = {},
				sqlls = {},
				textlsp = {},
				ts_ls = {},
				vimls = {},
				yamlls = {},
				-- sqls = {},
			}

			-- Список всех инструментов (LSP, линтеры, форматировщики) для Mason
			local ensure_installed = {
				"clang-format",
				"cmakelang",
				"editorconfig-checker",
				"eslint_d",
				"prettierd",
				"ruff",
				"rustfmt",
				"selene",
				"shellcheck",
				"shellharden",
				"shfmt",
				"sqlfluff",
				"stylua",
				"taplo",
				"vale",
				"vint",
			}

			-- Добавляем ключи из таблицы servers (все LSP) в общий список установки

			for server, _ in pairs(servers) do
				table.insert(ensure_installed, server)
			end

			mason_tool_installer.setup({
				ensure_installed = ensure_installed,
				auto_update = true,
				run_on_start = true,

				integrations = {
					["mason-lspconfig"] = true,
					["mason-nvim-dap"] = true,
				},
			})

			-- 4. ТРИГГЕР ДЛЯ АВТОУСТАНОВКИ (Best Practice 2026)
			-- Это заставит Mason начать скачивание сразу при запуске
			vim.schedule(function()
				mason_tool_installer.check_install()
			end)

			mason_lspconfig.setup({
				handlers = {
					function(server_name)
						local server_opts = servers[server_name] or {}
						-- capabilities НЕ прописываем вручную, blink.cmp делает это сам
						lspconfig[server_name].setup(server_opts)
					end,
				},
			})

			require("fidget").setup({

				opts = {
					notification = {},
					window = {
						-- winblend = 0, -- Непрозрачное окно для лучшей читаемости на Debian
					},

					logger = {
						-- level = vim.log.levels.WARN,
					},
				},
			})
			require("lsp-file-operations").setup()

			local signs = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = " ",
				[vim.diagnostic.severity.HINT] = "",
				[vim.diagnostic.severity.INFO] = "",
			}

			vim.diagnostic.config({
				signs = {
					text = signs,
				},

				-- Настройка виртуального текста (сообщения справа от кода)
				virtual_text = false, -- Отключаем текст справа, так как используем virtual_lines
				-- virtual_text = {
				-- 	prefix = "●",
				-- 	source = "if_many",
				-- 	severity_sort = true,
				-- },
				-- Встроенная поддержка виртуальных строк (диагностика под строкой)
				virtual_lines = { current_line = true },
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "if_many",
					focusable = false,
				},
			})

			-- Горячие клавиши (API 2026)
			-- Diagnostic Keymaps (2026 API)
			-- Переход между ошибками с автоматическим открытием плавающего окна
			-- Jump between diagnostics with automatic floating window
			vim.keymap.set("n", "[d", function()
				vim.diagnostic.jump({ count = -1, float = true })
			end, { desc = "Go to previous diagnostic", silent = true })

			vim.keymap.set("n", "]d", function()
				vim.diagnostic.jump({ count = 1, float = true })
			end, { desc = "Go to next diagnostic", silent = true })

			-- Показать описание в плавающем окне
			-- Show diagnostic details in a floating window
			vim.keymap.set(
				"n",
				"gl",
				vim.diagnostic.open_float,
				{ desc = "Show diagnostic error messages", silent = true }
			)

			-- Открыть список всех ошибок в проекте (Quickfix)
			-- Add all project diagnostics to the Quickfix list
			vim.keymap.set("n", "<leader>q", function()
				vim.diagnostic.setqflist()
			end, { desc = "Open diagnostic Quickfix list", silent = true })

			-- Открыть только ошибки (без предупреждений) в quickfix
			-- Filter and open only errors (excluding warnings) in Quickfix
			vim.keymap.set("n", "<leader>qe", function()
				vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
			end, { desc = "Open Quickfix list (Errors only)" })
		end,
	},

	-- Модуль линтинга (nvim-lint)
	{
		"mfussenegger/nvim-lint",
		-- event = { "BufReadPre", "BufNewFile" },
		event = { "BufReadPost", "BufWritePost", "InsertLeave" }, -- Ленивая загрузка
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				bash = { "shellcheck" },
				sh = { "shellcheck" },
				cpp = { "cppcheck" }, -- clang-tidy теперь работает через LSP, здесь он не нужен
				c = { "cppcheck" }, -- clang-tidy теперь работает через LSP, здесь он не нужен
				-- В 2026 eslint_d предпочтительнее для скорости
				javascript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescript = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				lua = { "selene" },
				-- markdown = { "markdownlint" },
				markdown = { "vale" },
				python = { "ruff" },
				vim = { "vint" },
			}

			-- Автокоманда для запуска линтинга
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
				-- Группа обязательна в 2026 году: предотвращает утечки памяти при перечитывании конфига
				group = vim.api.nvim_create_augroup("nvim_lint_config", { clear = true }),
				callback = function()
					-- 1. Пропускаем буферы, у которых нет файла (терминалы, Neo-tree, специальные окна)
					if vim.bo.buftype ~= "" then
						return
					end

					-- 2. Исключаем конкретные файлы по имени
					local bufname = vim.api.nvim_buf_get_name(0)
					if bufname:match("config%.h$") then
						return
					end
					-- Если таких исключений станет много (например, config.h, settings.json, init.vim), удобнее будет вынести их в таблицу:
					-- local exclude_files = { ["config.h"] = true, ["test.txt"] = true }
					-- if exclude_files[vim.fn.expand("%:t")] then return end

					-- 3. Запускаем линтинг
					-- Используем pcall, чтобы если линтер вдруг "отвалился" (например, Mason обновил vint),
					-- редактор не выкидывал ошибку на весь экран
					local ok, lint = pcall(require, "lint")
					if ok then
						lint.try_lint()
					end
				end,
			})
		end,
	},

	-- Форматирование (conform.nvim)
	{
		"stevearc/conform.nvim",
		-- event = { "BufWritePre" },
		event = { "BufReadPre", "BufNewFile" }, -- Загрузка для готовности к открытию файлов
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" }, function(err)
						-- Интеграция с fidget.nvim для уведомлений
						local ok, fidget = pcall(require, "fidget")
						if ok then
							if not err then
								fidget.notify("Formatting complete")
							else
								fidget.notify("Formatting failed", vim.log.levels.ERROR)
							end
						end
					end)
				end,
				mode = { "n", "v" },
				desc = "Format buffer/selection (Async)",
			},
		},
		opts = {

			formatters_by_ft = {
				-- Python: Ruff — лидер 2026 (заменяет black, isort, flake8)
				python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },

				-- Web-технологии: использование демона prettierd для скорости
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescriptreact = { "prettierd" },
				css = { "prettierd" },
				html = { "prettierd" },
				json = { "prettierd" },
				yaml = { "prettierd" },
				markdown = { "prettierd" },

				-- Системные языки
				lua = { "stylua" },
				sh = { "shfmt", "shellharden" },
				bash = { "shfmt", "shellharden" },
				zsh = { "shfmt", "shellharden" },

				-- Низкоуровневое программирование
				c = { "clang-format" },
				cpp = { "clang-format" },
				rust = { "rustfmt", lsp_format = "fallback" },
				toml = { "taplo" },
				cmake = { "cmake_format" },
			},
			-- format_on_save = { lsp_format = "fallback", timeout_ms = 500 },

			-- Настройка автоформатирования при сохранении
			format_on_save = function(bufnr)
				local bufname = vim.api.nvim_buf_get_name(bufnr)

				-- 1. Игнорировать любые файлы config.h
				if bufname:match("config%.h$") then
					return
				end

				-- 2. Отключение для определенных типов файлов (sql)
				local ignore_filetypes = { "sql" }
				if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
					return
				end

				-- 3. Параметры форматирования
				return { timeout_ms = 500, lsp_format = "fallback" }
			end,

			-- Настройки конкретных форматировщиков
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2", "-ci" }, -- Отступы 2 пробела, отступы для switch/case
				},
				-- В 2026 ruff_format по умолчанию следует правилам pyproject.toml
				ruff_format = {
					-- prepend_args = { "--line-length", "88" },
					-- args = { "format", "--line-length", "100", "--stdin-filename", "$FILENAME", "-" },
				},
			},

			-- Conform will notify you when a formatter errors
			notify_on_error = true,
			-- Conform will notify you when no formatters are available for the buffer
			notify_no_formatters = true,
		},
	},
}
