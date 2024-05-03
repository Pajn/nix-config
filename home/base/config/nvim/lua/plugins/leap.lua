return {
  {
    'ggandor/leap.nvim',
    dependencies = { 'tpope/vim-repeat' },
    keys = {
      { 's', '<Plug>(leap)', mode = { 'n' } },
      { 's', '<Plug>(leap-forward)', mode = { 'x', 'o' } },
      { 'S', '<Plug>(leap-backward)', mode = { 'x', 'o' } },
      { 'gs', '<Plug>(leap-from-window)', mode = { 'n', 'x', 'o' } },
    },
    config = function()
      require('leap')
    end,
  },
}
