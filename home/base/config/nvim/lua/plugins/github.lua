local keymaps = require 'user.keymaps'
return {
  {
    'pwntester/octo.nvim',
    cmd = 'Octo',
    keys = keymaps.octo,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'echasnovski/mini.icons',
    },
    config = function()
      require('octo').setup { enable_builtin = true }
    end,
  },
  {
    'dlvhdr/gh-addressed.nvim',
    cmd = 'GhReviewComments',
    keys = keymaps.gh_addressed,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'folke/trouble.nvim',
    },
  },
  {
    'dlvhdr/gh-blame.nvim',
    cmd = 'GhBlameCurrentLine',
    keys = keymaps.gh_blame,
    dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
  },
}
