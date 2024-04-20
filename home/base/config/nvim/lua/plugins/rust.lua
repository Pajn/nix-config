local map_lsp_keybinds = require('user.keymaps').map_lsp_keybinds

return {
  {
    'saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    config = function()
      ---@diagnostic disable-next-line: missing-parameter
      require('crates').setup()
    end,
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    ft = { 'rust' },
    opts = {
      server = {
        ---@diagnostic disable-next-line: unused-local
        on_attach = function(_client, bufnr)
          map_lsp_keybinds(bufnr)
        end,
      },
    },
  },
  -- {
  --   'vxpm/ferris.nvim',
  --   event = { 'BufRead *.rs' },
  --   opts = {
  --     -- your options here
  --   },
  -- },
}
