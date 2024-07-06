return {
  {
    'rasulomaroff/reactive.nvim',
    event = { 'VeryLazy' },
    config = function()
      require('reactive').setup {
        load = { 'catppuccin-frappe-cursor', 'catppuccin-frappe-cursorline' },
      }
    end,
  },
}
