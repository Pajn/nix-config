local keymaps = require 'user.keymaps'

return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      'nvim-telescope/telescope.nvim', -- optional
    },
    cmd = 'Neogit',
    keys = keymaps.neogit,
    config = true,
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
    config = true,
  },
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gdiffsplit', 'Gdiffget', 'Gdiff', 'Gblame', 'Gbrowse' },
    keys = keymaps.fugitive,
  },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        keymaps.gitsigns(bufnr)
      end,
    },
  },
  {
    'linrongbin16/gitlinker.nvim',
    keys = keymaps.gitlinker,
    config = function()
      require('gitlinker').setup()
    end,
  },
  {
    -- 'polarmutex/git-worktree.nvim',
    -- branch = 'v2',
    'ThePrimeagen/git-worktree.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    keys = keymaps.git_worktree,
    config = function()
      ---@diagnostic disable-next-line: missing-fields, missing-parameter
      require('git-worktree').setup {}
      require('telescope').load_extension 'git_worktree'
    end,
  },
  {
    'yutkat/git-rebase-auto-diff.nvim',
    ft = { 'gitrebase' },
    config = function()
      require('git-rebase-auto-diff').setup()
    end,
  },
  {
    'FabijanZulj/blame.nvim',
    cmd = { 'BlameToggle' },
    keys = keymaps.blame,
    opts = {},
  },
  {
    'moyiz/git-dev.nvim',
    lazy = true,
    cmd = { 'GitDevOpen', 'GitDevToggleUI', 'GitDevRecents', 'GitDevCleanAll' },
    opts = {},
  },
}
