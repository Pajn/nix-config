local keymaps = require 'user.keymaps'

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
    init = function()
      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {},
        -- LSP configuration
        server = {
          standalone = false,
          ---@diagnostic disable-next-line: unused-local
          on_attach = function(_client, bufnr)
            keymaps.lsp(bufnr)
          end,
          default_settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
              semanticHighlighting = {
                ['punctuation.enable'] = true,
                ['punctuation.separate.macro.bang'] = true,
              },
              diagnostics = {
                enable = true,
                -- disabled = { 'unresolved-method', 'unresolved-field' },
                experimental = { enable = true },
              },
              assist = {
                emitMustUse = true,
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
        -- DAP configuration
        dap = {},
      }
    end,
  },
}
