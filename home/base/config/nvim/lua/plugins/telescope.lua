local keymaps = require 'user.keymaps'

return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    {
      'isak102/telescope-git-file-history.nvim',
      dependencies = { 'tpope/vim-fugitive' },
    },
  },
  lazy = true,
  cmd = 'Telescope',
  keys = keymaps.telescope,
  config = function()
    local actions = require 'telescope.actions'
    local trouble = require 'trouble.sources.telescope'

    local function flash(prompt_bufnr)
      require('flash').jump {
        pattern = '^',
        label = { after = { 0, 0 } },
        search = {
          mode = 'search',
          exclude = {
            function(win)
              return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'TelescopeResults'
            end,
          },
        },
        action = function(match)
          local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
          picker:set_selection(match.pos[1] - 1)
        end,
      }
    end

    require('telescope').setup {
      defaults = {
        hidden = true,
        mappings = {
          i = { ['<c-t>'] = trouble.open_with_trouble, ['<c-s>'] = flash, ['<c-j>'] = actions.preview_scrolling_down, ['<c-k>'] = actions.preview_scrolling_up },
          n = { ['<c-t>'] = trouble.open_with_trouble, ['q'] = actions.close, s = flash },
        },
        path_display = { 'truncate' },
      },
      extensions = {
        git_file_history = {
          mappings = {
            i = {
              ['<c-g>'] = function()
                require('telescope').extensions.git_file_history.actions.open_in_browser {}
              end,
            },
            n = {
              ['<c-g>'] = function()
                require('telescope').extensions.git_file_history.actions.open_in_browser {}
              end,
            },
          },
        },
      },
    }

    -- Enable telescope fzf native, if installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'git_file_history')
  end,
}
