require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>gt", "<cmd>GitStatusFast<CR>", { desc = "Git status" })
map("n", "<leader>fs", "<cmd>Telescope grep_string<CR>", { desc = "grep word under cursor" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
