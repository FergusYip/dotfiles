require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>gt", "<cmd>GitStatusFast<CR>", { desc = "Git status" })
map("n", "<leader>fs", "<cmd>Telescope grep_string<CR>", { desc = "grep word under cursor" })
map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "LSP code action" })
map("n", "<leader>lh", vim.lsp.buf.hover, { desc = "LSP hover" })
map("n", "<leader>lr", "<cmd>Telescope lsp_references<CR>", { desc = "LSP references" })
map("n", "<leader>li", "<cmd>Telescope lsp_implementations<CR>", { desc = "LSP implementations" })
map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "LSP document symbols" })
map("n", "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "LSP diagnostics" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
