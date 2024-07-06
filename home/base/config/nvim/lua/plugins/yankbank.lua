return {
  'ptdewey/yankbank-nvim',
  config = function()
    require('yankbank').setup {
      max_entries = 19,
      num_behavior = 'jump',
    }
  end,
}
