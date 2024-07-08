local keymaps = require 'user.keymaps'

return {
  {
    'MagicDuck/grug-far.nvim',
    keys = keymaps.grug_far,
    config = function()
      require('grug-far').setup {}

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('extra-grug-far-keybinds', { clear = true }),
        pattern = { 'grug-far' },
        callback = function()
          keymaps.grug_far_buffer()
        end,
      })
    end,
  },
  {
    'chrisgrieser/nvim-rip-substitute',
    cmd = 'RipSubstitute',
    keys = keymaps.rip_substitute,
  },
}
