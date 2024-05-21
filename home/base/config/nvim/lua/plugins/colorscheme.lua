return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        background = { -- :h background
          light = 'latte',
          dark = 'frappe',
        },
        transparent_background = true,
        dim_inactive = { enable = true },
      }
      -- vim.cmd.colorscheme 'catppuccin'
    end,
  },

  {
    'sainnhe/everforest',
    lazy = false,
    priority = 1000,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.everforest_enable_italic = true
      -- vim.g.everforest_background = 'medium'
      vim.g.everforest_transparent_background = 1
      vim.cmd.colorscheme 'everforest'
    end,
  },

  -- {
  --   'rose-pine/neovim',
  --   name = 'rose-pine',
  --   priority = 1000,
  --   config = function()
  --     require('rose-pine').setup { styles = { transparency = true } }
  --     vim.cmd.colorscheme 'rose-pine'
  --   end,
  -- },

  {
    'SyedFasiuddin/theme-toggle-nvim',
    config = function()
      require('theme-toggle-nvim').setup {
        colorscheme = {
          light = 'everforest',
          dark = 'everforest',
        },
      }
    end,
  },
}
