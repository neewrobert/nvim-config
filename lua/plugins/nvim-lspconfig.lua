-- LSP Support
return {
  -- LSP Configuration
  -- https://github.com/neovim/nvim-lspconfig
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  dependencies = {
    -- LSP Management
    -- https://github.com/williamboman/mason.nvim
    { 'williamboman/mason.nvim' },
    -- https://github.com/williamboman/mason-lspconfig.nvim
    { 'williamboman/mason-lspconfig.nvim' },

    -- Auto-Install LSPs, linters, formatters, debuggers
    -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' },

    -- Useful status updates for LSP
    -- https://github.com/j-hui/fidget.nvim
    { 'j-hui/fidget.nvim',                        opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    -- https://github.com/folke/neodev.nvim
    { 'folke/neodev.nvim',                        opts = {} },
  },
  config = function()
    require('mason').setup()
    require('mason-lspconfig').setup({
      -- Install these LSPs automatically
      ensure_installed = {
        'bashls',
        'cssls',
        'html',
        'gradle_ls',
        'groovyls',
        'lua_ls',
        'jdtls',
        'jsonls',
        'lemminx',
        'marksman',
        'quick_lint_js',
        'yamlls',
        'vtsls',
        'eslint',
      }
    })

    require('mason-tool-installer').setup({
      -- Install these linters, formatters, debuggers automatically
      ensure_installed = {
        'java-debug-adapter',
        'java-test',
        'prettier',
      },
    })

    -- There is an issue with mason-tools-installer running with VeryLazy, since it triggers on VimEnter which has already occurred prior to this plugin loading so we need to call install explicitly
    -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim/issues/39
    vim.api.nvim_command('MasonToolsInstall')
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.json" },
      callback = function()
        vim.lsp.buf.format({ async = true })
      end
    })

    local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lsp_attach = function(client, bufnr)
      -- Create your keybindings here...
    end

    -- Configure LSP servers using the new vim.lsp.config API
    -- Lua LSP settings
    vim.lsp.config.lua_ls = {
      capabilities = lsp_capabilities,
      on_attach = lsp_attach,
      settings = {
        Lua = {
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { 'vim' },
          },
        },
      },
    }

    -- TypeScript LSP Configuration
    vim.lsp.config.vtsls = {
      capabilities = lsp_capabilities,
      on_attach = lsp_attach,
      root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
      settings = {
        vtsls = {
          enableMoveToFileCodeAction = true,
          completeFunctionCalls = true,
        }
      }
    }

    -- ESLint LSP Configuration
    vim.lsp.config.eslint = {
      capabilities = lsp_capabilities,
      on_attach = function(client, bufnr)
        -- Auto-fix on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll"
        })
      end,
      root_markers = { ".eslintrc.json", ".eslintrc.js", ".git" },
    }

    -- Configure other LSP servers
    local servers = { 'ts_ls', 'yamlls', 'jsonls' }
    for _, server in ipairs(servers) do
      if server ~= 'jdtls' then
        vim.lsp.config[server] = {
          capabilities = lsp_capabilities,
          on_attach = lsp_attach,
        }
      end
    end

    -- Enable LSP servers
    vim.lsp.enable({ 'lua_ls', 'vtsls', 'eslint', 'ts_ls', 'yamlls', 'jsonls' })

    -- Globally configure all LSP floating preview popups (like hover, signature help, etc)
    local open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "rounded" -- Set border to rounded
      return open_floating_preview(contents, syntax, opts, ...)
    end
  end
}
