return {
  -- {
  --   'catppuccin/nvim',
  --   name = 'catppuccin',
  --   priority = 1000,
  --   config = function()
  --     require('catppuccin').setup {
  --       background = { -- :h background
  --         light = 'latte',
  --         dark = 'frappe',
  --       },
  --       -- transparent_background = !vim.g.neovide,
  --       transparent_background = true,
  --       dim_inactive = { enable = true },
  --     }
  --     -- vim.cmd.colorscheme 'catppuccin'
  --   end,
  -- },

  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        style = 'storm',
        transparent = true,
        day_brightness = 0.4,
      }
      vim.cmd.colorscheme 'tokyonight'
    end,
  },

  {
    'SyedFasiuddin/theme-toggle-nvim',
    config = function()
      require('theme-toggle-nvim').setup {
        colorscheme = {
          light = 'tokyonight',
          dark = 'tokyonight',
          -- light = 'everforest',
          -- dark = 'everforest',
        },
      }
    end,
  },
}
