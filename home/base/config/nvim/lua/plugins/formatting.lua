local keymaps = require 'user.keymaps'
---@diagnostic disable: inject-field
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = keymaps.conform,
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  config = function()
    require('conform').setup {
      -- Define your formatters
      formatters_by_ft = {
        lua = { 'stylua' },
        nix = { 'nixfmt' },
        python = { 'isort', 'black' },

        javascript = { 'biome-check', 'prettier', stop_after_first = true },
        javascriptreact = { 'biome-check', 'prettier', stop_after_first = true },
        typescript = { 'biome-check', 'prettier', stop_after_first = true },
        typescriptreact = { 'biome-check', 'prettier', stop_after_first = true },
        vue = { 'prettier' },
        css = { 'biome-check', 'prettier', stop_after_first = true },
        scss = { 'biome-check', 'prettier', stop_after_first = true },
        less = { 'prettier' },
        html = { 'prettier' },
        json = { 'biome-check', 'prettier', stop_after_first = true },
        jsonc = { 'biome-check', 'prettier', stop_after_first = true },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
        ['markdown.mdx'] = { 'prettier' },
        graphql = { 'prettier' },
        handlebars = { 'prettier' },

        ['_'] = { 'trim_whitespace' },
      },

      -- Customize formatters
      formatters = {
        ['biome-check'] = {
          require_cwd = true,
        },
        prettier = {
          require_cwd = true,
        },
        shfmt = {
          prepend_args = { '-i', '2' },
        },
      },

      -- Set up format-on-save
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- Disable autoformat for files in a certain path
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match '/node_modules/' then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,

      -- There is a similar affordance for format_after_save, which uses BufWritePost.
      -- This is good for formatters that are too slow to run synchronously.
      format_after_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- Disable autoformat for files in a certain path
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match '/node_modules/' then
          return
        end
        return { lsp_fallback = true }
      end,
    }
    vim.api.nvim_create_user_command('FormatDisable', function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = 'Disable autoformat-on-save',
      bang = true,
    })
    vim.api.nvim_create_user_command('FormatEnable', function()
      vim.b.disable_autoformat = false
      if not args.bang then
        vim.g.disable_autoformat = false
      end
    end, {
      desc = 'Re-enable autoformat-on-save',
    })
  end,
}
