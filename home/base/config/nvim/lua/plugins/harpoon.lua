local keymaps = require 'user.keymaps'
return {
  -- {
  --   'ThePrimeagen/harpoon',
  --   lazy = true,
  --   keys = keymaps.harpoon,
  -- },
  {
    'fnune/recall.nvim',
    version = '*',
    keys = keymaps.recall,
    config = true,
  },
}
