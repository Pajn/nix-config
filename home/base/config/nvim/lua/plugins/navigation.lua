local keymaps = require 'user.keymaps'
return {
  {
    'mawkler/demicolon.nvim',
    keys = { ';', ',', 't', 'f', 'T', 'F', ']', '[', ']d', '[d' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {
      keymaps = {
        -- Create ]d/[d, etc. key mappings to jump to diganostics. See demicolon.keymaps.create_default_diagnostic_keymaps
        diagnostic_motions = false,
      },
    },
  },
  { 'echasnovski/mini.ai', version = false, opts = { n_lines = 50 } },
  {
    'echasnovski/mini.bracketed',
    version = false,
    keys = { '[', ']' },
    opts = {
      buffer = { suffix = '' },
      comment = { suffix = '' },
      conflict = { suffix = 'x', options = {} },
      diagnostic = { suffix = '' },
      file = { suffix = '' },
      indent = { suffix = 'i', options = {} },
      jump = { suffix = '' },
      location = { suffix = '' },
      oldfile = { suffix = 'o', options = {} },
      quickfix = { suffix = 'q', options = {} },
      treesitter = { suffix = ' ', options = {} },
      undo = { suffix = '' },
      window = { suffix = '' },
      yank = { suffix = '' },
    },
  },
  {
    'mawkler/refjump.nvim',
    keys = { ']r', '[r' },
    opts = {},
  },
  {
    'echasnovski/mini.move',
    version = false,
    keys = { { 'H', mode = 'v' }, { 'L', mode = 'v' }, { 'J', mode = 'v' }, { 'K', mode = 'v' } },
    opts = {
      mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = 'H',
        right = 'L',
        down = 'J',
        up = 'K',

        -- Move current line in Normal mode
        -- line_left = '<C-H>',
        -- line_right = '<C-L>',
        -- line_down = '<C-J>',
        -- line_up = '<C-K>',
      },
    },
  },
  {
    'kwkarlwang/bufjump.nvim',
    keys = keymaps.bufjump,
    opts = {
      forward_key = false,
      backward_key = false,
    },
  },
}
