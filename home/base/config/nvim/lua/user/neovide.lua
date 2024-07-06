vim.g.neovide_transparency = 0.8
vim.g.neovide_window_blurred = true
vim.g.neovide_theme = 'auto'
vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
-- Helper function for transparency formatting
local alpha = function()
  return string.format('%x', math.floor(255 * (vim.g.neovide_transparency or 0.8)))
end
vim.g.neovide_background_color = '#0f1117' .. alpha()
