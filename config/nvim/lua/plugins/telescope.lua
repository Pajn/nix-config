-- Fuzzy Finder (files, lsp, etc)
return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  lazy = true,
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  config = function()
    local trouble = require("trouble.providers.telescope")
    require('telescope').setup {
      defaults = {
        hidden = true,
        mappings = {
          i = { ['<c-t>'] = trouble.open_with_trouble },
          n = { ['<c-t>'] = trouble.open_with_trouble },
        },
      },
    }

    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')
  end,
}
