return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Treesitter %
  'yorickpeterse/nvim-tree-pairs',

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', event = 'VeryLazy', opts = {} },

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup { transparent_background = true }
      vim.cmd.colorscheme 'catppuccin-frappe'
    end,
  },
}
