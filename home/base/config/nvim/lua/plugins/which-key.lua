local keymaps = require 'user.keymaps'

return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = { icons = { rules = false }, spec = keymaps.which_key },
  },
}
