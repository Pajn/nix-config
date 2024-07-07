return {
  {
    'nvim-lualine/lualine.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('lualine').setup {
        options = {
          globalstatus = true,
          component_separators = { left = '', right = '' },
          section_separators = { left = '█', right = '█' },
        },
        sections = {
          lualine_b = {
            { 'branch', icon = '' },
            -- harpoon_component,
            'diff',
            'diagnostics',
          },
          lualine_c = {
            { 'filename', path = 1 },
          },
          lualine_x = {
            'overseer',
            'filetype',
          },
        },
      }
    end,
  },
}
