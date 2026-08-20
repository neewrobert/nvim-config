-- JDTLS (Java LSP) configuration
local jdtls = require('jdtls')
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.env.HOME .. '/jdtls-workspace/' .. project_name

-- Resolve an installed SDKMAN java home for a given major version, so this
-- file doesn't need machine-specific hardcoded patch/vendor versions.
local function sdkman_java_home(major)
  local candidates = vim.fn.glob(vim.env.HOME .. '/.sdkman/candidates/java/' .. major .. '.*', true, true)
  if #candidates == 0 then
    error('No SDKMAN java ' .. major .. '.x found; install one with `sdk install java ' .. major .. '.x-tem`')
  end
  table.sort(candidates)
  return candidates[#candidates]
end

local java21_home = sdkman_java_home(21)
local java17_home = sdkman_java_home(17)

-- jdtls ships OS/arch-specific launch configs; pick the right one for this machine.
local uname = vim.uv.os_uname()
local jdtls_config_dir = ({
  Darwin = { aarch64 = 'config_mac_arm', arm64 = 'config_mac_arm', x86_64 = 'config_mac' },
  Linux = { aarch64 = 'config_linux_arm', arm64 = 'config_linux_arm', x86_64 = 'config_linux' },
})[uname.sysname][uname.machine]

-- Needed for debugging
local bundles = {
  vim.fn.glob(vim.env.HOME .. '/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar'),
}

-- Needed for running/debugging unit tests
vim.list_extend(bundles, vim.split(vim.fn.glob(vim.env.HOME .. "/.local/share/nvim/mason/share/java-test/*.jar", 1), "\n"))

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    java21_home .. '/bin/java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:' .. vim.env.HOME .. '/.local/share/nvim/mason/share/jdtls/lombok.jar',
    '-Xmx4g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '--add-opens', 'java.base/java.nio.file=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang.reflect=ALL-UNNAMED',

    -- Eclipse jdtls location
    '-jar', vim.env.HOME .. '/.local/share/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher.jar',
    '-configuration', vim.env.HOME .. '/.local/share/nvim/mason/packages/jdtls/' .. jdtls_config_dir,
    '-data', workspace_dir
  },

  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'pom.xml', 'build.gradle'}),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  settings = {
    java = {
      home = java21_home,
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        -- The runtime name parameters need to match specific Java execution environments.
        runtimes = {
          {
            name = "JavaSE-17",
            path = java17_home,
          },
          {
            name = "JavaSE-21",
            path = java21_home,
          },
        },
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      signatureHelp = { enabled = true },
      format = {
        enabled = true,
        settings = {
          url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/intellij-java-google-style.xml",
          profile = "GoogleStyle",
        },
      },
    },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
      importOrder = {
        "java",
        "javax",
        "com",
        "org"
      },
    },
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 1,
        staticStarThreshold = 1,
      },
    },
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      useBlocks = true,
    },
  },
  -- Needed for auto-completion with method signatures and placeholders
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  flags = {
    allow_incremental_sync = true,
  },
  init_options = {
    -- References the bundles defined above to support Debugging and Unit Testing
    bundles = bundles
  },
}

-- Needed for debugging
config['on_attach'] = function(client, bufnr)
  jdtls.setup_dap({ hotcodereplace = 'auto' })
  require('jdtls.dap').setup_dap_main_class_configs()
end

-- This starts a new client & server, or attaches to an existing client & server based on the `root_dir`.
jdtls.start_or_attach(config)
