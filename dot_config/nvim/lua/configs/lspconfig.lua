require("nvchad.configs.lspconfig").defaults()

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    for _, lhs in ipairs { "<leader>wa", "<leader>wr", "<leader>wl" } do
      pcall(vim.keymap.del, "n", lhs, { buffer = args.buf })
    end
  end,
})

local servers = { "html", "cssls", "tsgo" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
