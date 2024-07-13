return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Treesitter %
  'yorickpeterse/nvim-tree-pairs',

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', event = 'VeryLazy', opts = { icons = { rules = false } } },

  {
    'mcauley-penney/visual-whitespace.nvim',
    config = true,
  },
  -- {
  --   'arminfro/hand-side-fix.nvim',
  --   event = 'BufEnter',
  --   opts = true,
  -- },
  { 'jmattaa/regedit.vim', cmd = 'Regedit' },
}
