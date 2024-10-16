local keymaps = require 'user.keymaps'

return {
  {
    '3rd/image.nvim',
    ft = { 'html', 'css' },
    opts = {
      backend = 'kitty',
      integrations = {
        html = {
          enabled = true,
        },
        css = {
          enabled = true,
        },
      },
    },
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'echasnovski/mini.icons',
      'MunifTanjim/nui.nvim',
      '3rd/image.nvim',
      'antosha417/nvim-lsp-file-operations',
    },
    keys = keymaps.neotree,
    cmd = 'Neotree',
    opts = {
      source_selector = {
        winbar = true,
        sources = {
          {
            source = 'filesystem',
            display_name = ' 󰉓 Files ',
          },
          {
            source = 'document_symbols',
            display_name = '  Symbols ',
          },
          {
            source = 'buffers',
            display_name = ' 󰈚 Buffers ',
          },
          {
            source = 'git_status',
            display_name = ' 󰊢 Git ',
          },
        },
      },
      filesystem = {
        filtered_items = {
          visible = true,
        },
        window = {
          mappings = {
            ['\\'] = 'close_window',
          },
        },
      },
      nesting_rules = {
        ['package.json'] = {
          pattern = '^package%.json$',
          files = { 'package-lock.json', 'yarn*', 'pnpm-*' },
        },
        ['js-extended'] = {
          pattern = '(.+)%.js$',
          files = { '%1.js.map', '%1.min.js', '%1.d.ts' },
        },
        ['docker'] = {
          pattern = '^dockerfile$',
          ignore_case = true,
          files = { '.dockerignore', 'docker-compose.*', 'dockerfile*' },
        },
      },
    },
    config = function(_, opts)
      require('lsp-file-operations').setup()
      require('neo-tree').setup(opts)
    end,
  },
}
