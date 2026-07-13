return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "folke/which-key.nvim",
    opts = {
      delay = 0,
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope", "GitStatusFast" },
    config = function(_, opts)
      require("telescope").setup(opts)
      vim.api.nvim_create_user_command("GitStatusFast", function()
        require("configs.git_status").open()
      end, {})
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
