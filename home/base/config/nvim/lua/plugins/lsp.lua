local map_lsp_keybinds = require('user.keymaps').map_lsp_keybinds -- Has to load keymaps before pluginslsp

local on_attach = function(_client, buffer_number)
  -- Pass the current buffer to map lsp keybinds
  map_lsp_keybinds(buffer_number)

  -- if client.server_capabilities.codeLensProvider then
  -- 	vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "CursorHold" }, {
  -- 		buffer = buffer_number,
  -- 		callback = vim.lsp.codelens.refresh,
  -- 		desc = "LSP: Refresh code lens",
  -- 		group = vim.api.nvim_create_augroup("codelens", { clear = true }),
  -- 	})
  -- end
end

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'LspInfo', 'LspInstall', 'LspUninstall', 'Mason' },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Common JSON/YAML schemas
      'b0o/schemastore.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      -- { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      -- 'folke/neodev.nvim',
    },
    config = function()
      -- before setting up the servers.
      require('mason').setup()
      require('mason-lspconfig').setup()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. They will be passed to
      --  the `settings` field of the server config. You must look up that documentation yourself.
      --
      --  If you want to override the default filetypes that your language server will attach to you can
      --  define the property 'filetypes' to the map in question.
      local servers = {
        dockerls = {},
        -- clangd = {},
        biome = {},
        cssls = {},
        eslint = {
          settings = { rulesCustomizations = {
            { rule = '*', severity = 'warn' },
          } },
        },
        graphql = {},
        -- gopls = {},
        html = { filetypes = { 'html', 'twig', 'hbs' } },
        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },
        -- pyright = {},

        -- Rust and Typecript has custom configs
        -- rust_analyzer = {},
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                -- You must disable built-in schemaStore support if you want to use
                -- this plugin and its advanced options like `ignore`.
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                url = '',
              },
              schemas = require('schemastore').yaml.schemas(),
            },
          },
        },
      }
      local non_install_servers = {
        nil_ls = {},
      }

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- Ensure the servers above are installed
      local mason_lspconfig = require 'mason-lspconfig'

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      -- Iterate over our servers and set them up
      for server_name, config in pairs(servers) do
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = config.settings,
          filetypes = config.filetypes,
          handlers = config.handlers,
        }
      end
      for server_name, config in pairs(non_install_servers) do
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          on_attach = on_attach,
          settings = config.settings,
          filetypes = config.filetypes,
          handlers = config.handlers,
        }
      end
    end,
  },
  {
    'folke/neodev.nvim',
    ft = { 'lua', 'vim' },
    config = function()
      require('neodev').setup()
      require('lspconfig').lua_ls.setup {
        on_attach = function(client, bufnr)
          -- Setup neovim lua configuration
          require('neodev').setup()
          on_attach(client, bufnr)
        end,
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      }
    end,
  },
  {
    'nvimdev/lspsaga.nvim',
    event = 'LspAttach',
    config = function()
      require('lspsaga').setup {
        lightbulb = { enable = false },
      }
    end,
  },
  -- {
  --   'Maan2003/lsp_lines.nvim',
  --   event = 'LspAttach',
  --   config = function()
  --     require('lsp_lines').setup()
  --     vim.diagnostic.config { virtual_text = false }
  --   end,
  -- },
  {
    'folke/trouble.nvim',
    cmd = { 'Trouble', 'TroubleToggle' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },
  {
    'zeioth/garbage-day.nvim',
    dependencies = 'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'jdrupal-dev/parcel.nvim',
    dependencies = {
      'phelipetls/jsonpath.nvim',
    },
    opts = {},
  },
}
