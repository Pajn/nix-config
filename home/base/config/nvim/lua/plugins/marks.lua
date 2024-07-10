local keymaps = require 'user.keymaps'
return {
  {
    'fnune/recall.nvim',
    version = '*',
    keys = keymaps.recall,
    config = true,
  },
}
