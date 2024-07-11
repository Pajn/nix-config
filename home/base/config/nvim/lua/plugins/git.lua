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
  {
    'aaronhallaert/advanced-git-search.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      -- to show diff splits and open commits in browser
      'tpope/vim-fugitive',
      -- to open commits in browser with fugitive
      'tpope/vim-rhubarb',
      -- optional: to replace the diff from fugitive with diffview.nvim
      -- (fugitive is still needed to open in browser)
      'sindrets/diffview.nvim',
    },
    cmd = { 'AdvancedGitSearch' },
    config = function()
      -- optional: setup telescope before loading the extension
      require('telescope').setup {
        -- move this to the place where you call the telescope setup function
        extensions = {
          advanced_git_search = {
            -- See Config
          },
        },
      }

      require('telescope').load_extension 'advanced_git_search'
    end,
    opts = {
      diff_plugin = 'diffview',
    },
  },
}
