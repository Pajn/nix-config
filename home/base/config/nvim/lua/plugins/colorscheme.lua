local colorscheme = 'sweetie'

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
      if colorscheme == 'tokyonight' then
        vim.cmd.colorscheme 'tokyonight'
      end
    end,
  },

  {
    'NTBBloodbath/sweetie.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.sweetie = {

        pumblend = {
          enable = true,
          transparency_amount = 20,
        },
        integrations = {
          lazy = true,
          neorg = true,
          neogit = true,
          neomake = true,
          telescope = true,
        },
        -- Enable custom cursor coloring even in terminal Neovim sessions
        cursor_color = true,
        -- Use sweetie's palette in `:terminal` instead of your default terminal colorscheme
        terminal_colors = true,
      }
      require 'sweetie'
      if colorscheme == 'sweetie' then
        vim.cmd.colorscheme 'sweetie'
      end
    end,
  },

  {
    'SyedFasiuddin/theme-toggle-nvim',
    config = function()
      require('theme-toggle-nvim').setup {
        colorscheme = {
          light = colorscheme,
          dark = colorscheme,
        },
      }
    end,
  },
}
