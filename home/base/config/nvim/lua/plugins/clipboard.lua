local keymaps = require 'user.keymaps'

return {
  { 'ibhagwan/smartyank.nvim', opts = { highlight = { timeout = 300 } } },
  {
    'ptdewey/yankbank-nvim',
    lazy = false,
    keys = keymaps.yankbank,
    opts = {
      max_entries = 19,
      num_behavior = 'jump',
      sep = '    ',
      focus_gain_poll = true,
    },
  },
}
