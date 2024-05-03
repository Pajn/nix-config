return {
  {
    'echasnovski/mini.surround',
    version = false,
    keys = {
      { '<A-s>a', mode = { 'n', 'x' }, desc = '[S]urround [A]dd' },
      { '<A-s>d', mode = { 'n', 'x' }, desc = '[S]urround [D]elete' },
      { '<A-s>f', mode = { 'n', 'x' }, desc = '[S]urround [F]ind next' },
      { '<A-s>F', mode = { 'n', 'x' }, desc = '[S]urround [F]ind previous' },
      { '<A-s>h', mode = { 'n', 'x' }, desc = '[S]urround [H]ighlight' },
      { '<A-s>r', mode = { 'n', 'x' }, desc = '[S]urround [R]eplace' },
      { '<A-s>n', mode = { 'n', 'x' }, desc = '[S]urround [N]eighbor' },
    },
    opts = {
      mappings = {
        add = '<A-s>a', -- Add surrounding in Normal and Visual modes
        delete = '<A-s>d', -- Delete surrounding
        find = '<A-s>f', -- Find surrounding (to the right)
        find_left = '<A-s>F', -- Find surrounding (to the left)
        highlight = '<A-s>h', -- Highlight surrounding
        replace = '<A-s>r', -- Replace surrounding
        update_n_lines = '<A-s>n', -- Update `n_lines`

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
      },
    },
  },
}
