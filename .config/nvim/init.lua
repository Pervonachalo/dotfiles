-- 1. Лидер-клавиши (должны быть объявлены ПЕРЕД загрузкой плагинов)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- vim.g.maplocalleader = " "

-- 2. Подключение модулей ядра
require("core.options") -- Сначала базовые опции
require("core.keymaps") -- Потом горячие клавиши

-- 3. Инициализация менеджера плагинов
require("core.lazy") -- И в конце загрузка плагинов
