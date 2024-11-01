local keymaps = require 'user.keymaps'

return {
  {
    'fnune/recall.nvim',
    version = '*',
    keys = keymaps.recall,
    config = true,
  },
  {
    'gcmt/vessel.nvim',
    cmds = { 'Marks', 'Jumps', 'Buffers' },
    keys = keymaps.vessel,
    opts = {
      create_commands = true,
      commands = {
        view_marks = 'Marks',
        view_jumps = 'Jumps',
        view_buffers = 'Buffers',
      },
    },
  },
}
