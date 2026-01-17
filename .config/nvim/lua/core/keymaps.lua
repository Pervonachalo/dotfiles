-- 1. Системные настройки лидера (должны быть в init.lua до плагинов, но оставим тут для справки)
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

-- 2. Навигация по окнам (стандартный блок)
local map = vim.keymap.set
map("n", "<C-l>", "<C-w>l", { desc = "Window Right" })
map("n", "<C-h>", "<C-w>h", { desc = "Window Left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window Down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window Up" })

-- 3. Работа с табами (BufferLine)
map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
map("n", "<s-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
map("n", "<leader>x", "<cmd>BufferLinePickClose<cr>", { desc = "Pick Buffer to Close" })
map("n", "<leader>X", "<cmd>BufferLineCloseRight<cr>", { desc = "Close Buffers to Right" })
map("n", "<leader>s", "<cmd>BufferLineSortByTabs<cr>", { desc = "Sort Buffers by Tabs" })

-- 4. Neo-tree (Блок навигации)
-- Используем <leader>e как вы привыкли. Остальные маппинги сгруппированы.
map("n", "<leader>e", "<cmd>Neotree toggle reveal<cr>", { desc = "Explorer Toggle" })
map("n", "<leader>E", "<cmd>Neotree float reveal<cr>", { desc = "Explorer Float" })
map("n", "<leader>o", "<cmd>Neotree focus reveal_force_cwd<cr>", { desc = "Neo-tree (Focus)" })
map("n", "<leader>go", "<cmd>Neotree float git_status<cr>", { desc = "Git Status (Neo-tree)" })

-- 5. Поиск и визуальное удобство
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear Highlight" })
map("i", "jj", "<Esc>", { desc = "Escape to Normal Mode" })

-- 6. Орфография (v0.11+ поддерживает расширенный spell)
map("n", "<F11>", "<cmd>set spell!<cr>", { desc = "Toggle Spellcheck" })
map("i", "<F11>", "<C-O><cmd>set spell!<cr>", { desc = "Toggle Spellcheck" })

-- 7. Умное удаление и change (Best Practice 2026)
-- Удаление и change без копирования в буфер обмена (black hole register)
map({ "n", "x" }, "x", '"_x')
map("n", "c", '"_c')

-- 8. Системный буфер обмена (удобно для Debian)
-- Позволяет копировать в буфер системы через <leader>y
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to System Clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Copy Line to System Clipboard" })

-- 9. Перемещение выделенных строк вверх/вниз
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- 10. Центрирование при поиске
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
