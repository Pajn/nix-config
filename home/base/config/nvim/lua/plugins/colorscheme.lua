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
      vim.cmd.colorscheme 'catppuccin'
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
          light = 'catppuccin',
          dark = 'catppuccin',
        },
      }
    end,
  },
}
