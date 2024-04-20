if vim.g.vscode then
  -- VSCode extension

  -- Case-insensitive searching UNLESS \C or capital in search
  vim.o.ignorecase = true
  vim.o.smartcase = true

  return
else
  -- Neovim
end

require 'user'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
