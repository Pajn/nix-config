local keymaps = require 'user.keymaps'
return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'mrcjkb/rustaceanvim',
      'marilari88/neotest-vitest',
      'nvim-neotest/neotest-jest',
    },
    keys = keymaps.neotest,
    cmd = 'Neotest',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('neotest').setup {
        adapters = {
          require 'rustaceanvim.neotest',
          require 'neotest-vitest',
          require 'neotest-jest' {
            -- jestCommand = 'npm test --',
            -- jestConfigFile = 'custom.jest.config.ts',
            -- env = { CI = true },
            -- cwd = function(path)
            --   return vim.fn.getcwd()
            -- end,
          },
        },
        consumers = {
          overseer = require 'neotest.consumers.overseer',
        },
      }
    end,
  },
}
