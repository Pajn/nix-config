local vvar = vim.api.nvim_get_vvar
return {
  {
    'numToStr/Comment.nvim',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      config = function()
        ---@diagnostic disable-next-line: missing-fields
        require('ts_context_commentstring').setup {
          enable_autocmd = false,
        }
      end,
    },
    keys = {
      { 'gc', '<Plug>(comment_toggle_linewise)', mode = { 'n' }, desc = 'Comment toggle linewise' },
      { 'gb', '<Plug>(comment_toggle_blockwise)', mode = { 'n' }, desc = 'Comment toggle blockwise' },
      {
        'gcc',
        function()
          return vvar 'count' == 0 and '<Plug>(comment_toggle_linewise_current)' or '<Plug>(comment_toggle_linewise_count)'
        end,
        expr = true,
        mode = 'n',
        desc = 'Comment toggle current line',
      },
      {
        'gbb',
        function()
          return vvar 'count' == 0 and '<Plug>(comment_toggle_blockwise_current)' or '<Plug>(comment_toggle_blockwise_count)'
        end,
        mode = 'n',
        expr = true,
        desc = 'Comment toggle current block',
      },
      {
        'gc',
        '<Plug>(comment_toggle_linewise_visual)',
        mode = 'x',
        desc = 'Comment toggle linewise (visual)',
      },
      {
        'gb',
        '<Plug>(comment_toggle_blockwise_visual)',
        mode = 'x',
        desc = 'Comment toggle blockwise (visual)',
      },
      {
        'gco',
        "<cmd>lua require('Comment.api').insert.linewise.below()<cr>",
        mode = 'n',
        desc = 'Comment insert below',
      },
      {
        'gcO',
        "<cmd>lua require('Comment.api').insert.linewise.above()<cr>",
        mode = 'n',
        desc = 'Comment insert above',
      },
      {
        'gcA',
        "<cmd>lua require('Comment.api').insert.linewise.eol()<cr>",
        mode = 'n',
        desc = 'Comment insert end of line',
      },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('Comment').setup {
        mappings = {
          basic = false,
          extra = false,
        },
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
  },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VeryLazy',
    opts = {
      signs = false,
    },
  },
}
