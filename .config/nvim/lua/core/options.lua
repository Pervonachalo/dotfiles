-- luacheck: globals vim
-- local api = vim.api
local opt = vim.opt

-- Отключение встроенного netrw для корректной работы Neo-tree и Neogit
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 1. Цвета и интерфейс
opt.termguicolors = true --- Correct terminal colors
-- vim.cmd("colorscheme onedark") -- Цветовая схема
-- Рекомендуется сначала настроить опции, а потом загружать схему
-- vim.cmd.colorscheme("onedark") -- здесь тему больше не нужно прописывать, она автоматом запускается из плагина.

-- 2. Нумерация строк
opt.number = true -- отобразить слева нумерацию строк
opt.relativenumber = true -- нумерация строк относительно текущего положения курсора

-- 3. Отступы (Indent Settings)
opt.expandtab = true -- Использовать пробелы вместо табуляции
opt.shiftwidth = 4 -- Размер отступа
opt.tabstop = 4 -- 1 tab == 4 spaces определяет, каким количеством пробелов будет равен 1 таб
opt.softtabstop = 4 -- то же самое что и tabstop, но в режиме вставки
opt.smarttab = true -- умные проставления табов
opt.autoindent = true -- для автоматического отступа
-- opt.smartindent = true -- LSP и Treesitter справляются с отступами гораздо лучше

-- 4. UI и поведение
opt.signcolumn = "yes:1" -- Стабильная ширина колонки значков
opt.scrolloff = 8 -- прокрутка по вертикали
opt.sidescrolloff = 8 -- прокрутка по горизонтали
opt.cursorline = true -- Подсветка строки с курсором
opt.clipboard = "unnamedplus"
-- opt.encoding = "utf-8" -- В Neovim по умолчанию всегда используется utf-8. Эту строку можно удалить, она избыточна.
opt.spelllang = { "ru_yo", "en_us" } -- Словари рус eng
opt.smoothscroll = true -- Это делает прокрутку длинных (завернутых) строк гораздо более плавной, что является одной из киллер-фич последних версий.
opt.updatetime = 250 -- Быстрый отклик системы -- Увеличиваем время отображения сообщений (по умолчанию может быть слишком малым)
opt.timeoutlen = 300 -- Быстрое срабатывание комбо-клавиш
-- Настройка отображения сообщений
-- opt.shortmess:remove("F") -- Показывать уведомления, даже если они длинные
-- opt.shortmess:append("I") -- Убрать только приветствие при старте

-- 5. Русская раскладка
-- В vim есть встроенная поддержка русской раскладки. Мы можем переключаться на нее и обратно с помощью Ctrl-6, при этом при включенной русской, связки клавиш продолжат работать.
opt.keymap = "russian-jcukenwin"
opt.iminsert = 0
opt.imsearch = 0

-- 6. Заполнение символов (Fillchars)
opt.fillchars = {
	vert = "▕", -- alternatives │
	fold = " ",
	eob = " ", -- Убираем тильды (~) в конце буфера
	diff = "╱", -- alternatives = ⣿ ░ ─
	msgsep = "‾",
	foldopen = "▾",
	foldsep = "│",
	foldclose = "▸",
}

-- 7. Фолдинг
-- opt.foldmethod = "manual"
opt.foldmethod = "marker"

-- 9. Автокоманды (Общая группа)
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- 10. Восстановление позиции курсора
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Восстановить позицию курсора при открытии файла",
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
		end
	end,
})

-- 11. Назначение filetype для Conky
-- В 0.11 можно использовать vim.filetype.add() — это работает быстрее, чем autocmd
vim.filetype.add({
	pattern = {
		[".*conkyrc.*%.conf"] = "lua",
		["%.conkyrc.*"] = "lua",
	},
})

-- 12. Подсветка при копировании (Полезное дополнение для 2026 года)
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	desc = "Подсветка выделенного текста при копировании",
	callback = function()
		vim.highlight.on_yank({ hlgroup = "Visual", timeout = 500 })
	end,
})
