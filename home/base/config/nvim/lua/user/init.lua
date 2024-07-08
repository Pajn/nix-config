print 'testing'
require 'user.options'
if vim.g.neovide then
  require 'user.neovide'
end
require 'user.lazy'
require 'user.keymaps'
require 'user.vertical_help'
require 'user.edit_text'
