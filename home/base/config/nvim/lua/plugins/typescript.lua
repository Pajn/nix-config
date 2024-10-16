local keymaps = require 'user.keymaps'
---@type LazySpec
return {
  -- {
  --   'pmizio/typescript-tools.nvim',
  --   ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  --   dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  --   config = function()
  --     local api = require 'typescript-tools.api'
  --     require('typescript-tools').setup {
  --       ---@diagnostic disable-next-line: unused-local
  --       on_attach = function(_client, bufnr)
  --         keymaps.map_lsp_keybinds(bufnr)
  --       end,
  --       settings = {
  --         jsx_close_tag = { enable = false },
  --       },
  --       handlers = {
  --         ['textDocument/publishDiagnostics'] = api.filter_diagnostics {
  --           80001, -- Ignore 'Module may be converted from CommonJS' diagnostics.
  --           80006, -- Ignore 'This may be converted to an async function' diagnostics.
  --         },
  --       },
  --     }
  --   end,
  -- },
  {
    'dmmulroy/tsc.nvim',
    -- ft = { "typescript", "typescriptreact" },
    cmd = { 'TSC' },
    config = function()
      require('tsc').setup {
        auto_open_qflist = true,
        use_trouble_qflist = true,
        pretty_errors = true,
      }
    end,
  },
  {
    'vuki656/package-info.nvim',
    keys = keymaps.package_info,
    dependencies = { 'MunifTanjim/nui.nvim' },
    config = function()
      require('package-info').setup()
      require('telescope').load_extension 'package_info'
    end,
  },
  {
    'ryoppippi/nvim-pnpm-catalog-lens',
    -- event = 'BufEnter package.json',
    lazy = false,
  },
}
