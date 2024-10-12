local keymaps = require 'user.keymaps'

return {
  'andrewferrier/debugprint.nvim',
  opts = {
    keymaps = {
      normal = {
        plain_below = 'g?p',
        plain_above = 'g?P',
        variable_below = 'g?v',
        variable_above = 'g?V',
        variable_below_alwaysprompt = nil,
        variable_above_alwaysprompt = nil,
        textobj_below = 'g?o',
        textobj_above = 'g?O',
        toggle_comment_debug_prints = nil,
        delete_debug_prints = nil,
      },
      visual = {
        variable_below = 'g?v',
        variable_above = 'g?V',
      },
    },
    commands = {
      toggle_comment_debug_prints = 'DebugPrintToggleComment',
      delete_debug_prints = 'DebugPrintsDelete',
    },
  },
  keys = keymaps.debugprint,
  cmd = {
    'DebugPrintsToggleComment',
    'DebugPrintsDelete',
  },
  version = '*',
}
