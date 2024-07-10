-- return {
--   'brenoprata10/nvim-highlight-colors',
--   event = "VeryLazy",
--   config = function()
--     require("nvim-highlight-colors").turnOn()
--   end
-- }
return {
  {
    'uga-rosa/ccc.nvim',
    event = 'VeryLazy',
    config = function()
      local ccc = require 'ccc'
      ccc.setup {
        inputs = {
          ccc.input.hsl,
          ccc.input.rgb,
          ccc.input.hsluv,
          ccc.input.okhsl,
        },
        outputs = {
          ccc.output.hex,
          ccc.output.css_rgb,
          ccc.output.css_hsl,
        },
        -- pickers = {
        --   ccc.picker.ansi_escape({
        --     foreground = '#cccccc',
        --     background = '#0c0c0c',
        --     black = '#0c0c0c',
        --     red = '#c50f1f',
        --     green = '#13a10e',
        --     yellow = '#c19c00',
        --     blue = '#0037da',
        --     magenta = '#881798',
        --     cyan = '#3a96dd',
        --     white = '#cccccc',
        --     bright_black = '#767676',
        --     bright_red = '#e74856',
        --     bright_green = '#16c60c',
        --     bright_yellow = '#f9f1a5',
        --     bright_blue = '#3b78ff',
        --     bright_magenta = '#b4009e',
        --     bright_cyan = '#61d6d6',
        --     bright_white = '#f2f2f2',
        --   }, {
        --     -- `\e[31;1m` means whether `red + bold` or `bright red`.
        --     ---@type "bold"|"bright" Meaning of code 1. default: "bright"
        --     meaning1 = 'bright',
        --   }),
        -- },
        highlighter = {
          auto_enable = true,
        },
      }
    end,
  },
}
