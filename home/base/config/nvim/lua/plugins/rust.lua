local map_lsp_keybinds = require('user.keymaps').map_lsp_keybinds

vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {},
  -- LSP configuration
  server = {
    ---@diagnostic disable-next-line: unused-local
    on_attach = function(_client, bufnr)
      map_lsp_keybinds(bufnr)
    end,
    default_settings = {
      -- rust-analyzer language server configuration
      ['rust-analyzer'] = {},
    },
  },
  -- DAP configuration
  dap = {},
}

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
    -- ft = { 'rust' },
    lazy = false, -- This plugin is already lazy
  },
  -- {
  --   'vxpm/ferris.nvim',
  --   event = { 'BufRead *.rs' },
  --   opts = {
  --     -- your options here
  --   },
  -- },
}
