return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'pnx/lualine-lsp-status' },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local function worktree()
        local res, match = vim.fn.FugitiveGitDir():gsub('.*worktrees/', '')
        if match == 1 then
          return res
        else
          return ''
        end
      end

      require('lualine').setup {
        options = {
          globalstatus = true,
          component_separators = { left = '', right = '' },
          section_separators = { left = '█', right = '█' },
        },
        sections = {
          lualine_b = {
            worktree,
            { 'branch', icon = '' },
            'diff',
          },
          lualine_c = {
            'diagnostics',
            { 'filename', path = 1 },
          },
          lualine_x = {
            -- {
            --   require('noice').api.statusline.mode.get,
            --   cond = require('noice').api.statusline.mode.has,
            --   color = { fg = '#ff9e64' },
            -- },
            'overseer',
            'lsp-status',
            'filetype',
          },
        },
        extensions = { 'quickfix', 'neo-tree', 'overseer', 'trouble' },
      }
    end,
  },
}
