-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny


vim.opt.wrap = true
vim.opt.autochdir = false
vim.opt.relativenumber = true
lvim.colorscheme = "dracula"
lvim.format_on_save.enabled = true

lvim.builtin.nvimtree.setup.sync_root_with_cwd = false

lvim.keys.normal_mode["<C-d>"] = "<C-d>zz"
lvim.keys.normal_mode["<C-u>"] = "<C-u>zz"
lvim.keys.normal_mode["<S-h>"] = ":bprev<CR>"
lvim.keys.normal_mode["<S-l>"] = ":bnext<CR>"

lvim.builtin.which_key.mappings["f"] = {
  "<cmd>FzfLua files<CR>", "Find File"
}
lvim.builtin.which_key.mappings["s"]["f"] = {
  "<cmd>FzfLua files<CR>", "Find File"
}
lvim.builtin.which_key.mappings["s"]["t"] = {
  "<cmd>FzfLua live_grep_native<CR>", "Text"
}

lvim.plugins = {
  { "dracula/vim" },
  { "christoomey/vim-tmux-navigator" },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({
        winopts = {
          fullscreen = true
        }
      })
    end
  },
}
