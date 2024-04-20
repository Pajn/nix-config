---@diagnostic disable: inject-field
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      -- Customize or remove this keymap to your liking
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
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

        javascript = { { 'prettier' } },
        javascriptreact = { { 'prettier' } },
        typescript = { { 'prettier' } },
        typescriptreact = { { 'prettier' } },
        vue = { { 'prettier' } },
        css = { { 'prettier' } },
        scss = { { 'prettier' } },
        less = { { 'prettier' } },
        html = { { 'prettier' } },
        json = { { 'prettier' } },
        jsonc = { { 'prettier' } },
        yaml = { { 'prettier' } },
        markdown = { { 'prettier' } },
        ['markdown.mdx'] = { { 'prettier' } },
        graphql = { { 'prettier' } },
        handlebars = { { 'prettier' } },

        ['_'] = { 'trim_whitespace' },
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
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { '-i', '2' },
        },
      },
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
      vim.g.disable_autoformat = false
    end, {
      desc = 'Re-enable autoformat-on-save',
    })
  end,
}
