require "nvchad.mappings"

pcall(vim.keymap.del, "n", "<leader>fm")
pcall(vim.keymap.del, "x", "<leader>fm")
pcall(vim.keymap.del, "n", "<leader>gt")
pcall(vim.keymap.del, "n", "<leader>ds")
pcall(vim.keymap.del, "n", "<leader>cm")
pcall(vim.keymap.del, "n", "<leader>ma")
pcall(vim.keymap.del, "n", "<leader>pt")

require("which-key").add {
  { "<leader>f", group = "Find", mode = "n" },
  { "<leader>g", group = "Git", mode = "n" },
  { "<leader>l", group = "LSP", mode = "n" },
  { "<leader>y", group = "Yank", mode = "n" },
}

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Write file" })
map("n", "H", function()
  require("nvchad.tabufline").prev()
end, { desc = "Previous buffer" })
map("n", "L", function()
  require("nvchad.tabufline").next()
end, { desc = "Next buffer" })
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
map("n", "<leader>gs", "<cmd>GitStatusFast<CR>", { desc = "Git status" })
map("n", "<leader>gu", "<cmd>Telescope git_status<CR>", { desc = "Git status (includes untracked)" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })
map("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Find files" })
map("n", "<leader>fa", "<cmd>FzfLua files hidden=true no_ignore=true follow=true<CR>", { desc = "Find all files" })
map("n", "<leader>fs", "<cmd>FzfLua grep_cword<CR>", { desc = "Grep word under cursor" })
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "Find marks" })
map("n", "<leader>ft", "<cmd>Telescope terms<CR>", { desc = "Find terminals" })
local function copy_file_path(modifier, label)
  local path = vim.fn.fnamemodify(vim.fn.expand "%:p", modifier)
  if path == "" then
    return
  end
  vim.fn.setreg("+", path)
  vim.notify("Copied " .. label .. " path: " .. path)
end

map("n", "<leader>yp", function()
  copy_file_path(":.", "relative")
end, { desc = "Copy relative file path" })
map("n", "<leader>ya", function()
  copy_file_path(":p", "absolute")
end, { desc = "Copy absolute file path" })
map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "LSP code action" })
map("n", "<leader>lh", vim.lsp.buf.hover, { desc = "LSP hover" })
map("n", "<leader>lr", "<cmd>Telescope lsp_references<CR>", { desc = "LSP references" })
map("n", "<leader>li", "<cmd>Telescope lsp_implementations<CR>", { desc = "LSP implementations" })
map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "LSP document symbols" })
map("n", "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "LSP diagnostics" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
