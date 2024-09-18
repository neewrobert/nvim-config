-- Configuration for running code based on filetype
return {
  -- https://github.com/CRAG666/code_runner.nvim
  'CRAG666/code_runner.nvim',
  event = 'VeryLazy',  -- Load when needed
  config = function()
    require('code_runner').setup({
      filetype = {
        java = function()
          -- Get the full path of the current file
          local filePath = vim.fn.expand('%:p')
          local fileName = vim.fn.expand('%:t')
          local fileNameWithoutExt = vim.fn.expand('%:t:r')

          -- Find the project root (assumed to be the directory containing 'src')
          local projectRoot = vim.fn.getcwd()
          while projectRoot ~= '/' and not vim.loop.fs_stat(projectRoot .. '/src') do
            projectRoot = vim.fn.fnamemodify(projectRoot, ':h')
          end
          if projectRoot == '/' then
            projectRoot = vim.fn.getcwd()
          end

          -- Define source and output directories
          local srcDir = projectRoot .. '/src'
          local outDir = projectRoot .. '/out'

          -- Read the package name from the Java file
          local packageName = ''
          for line in io.lines(filePath) do
            local match = string.match(line, '^%s*package%s+([%w%.]+)%s*;')
            if match then
              packageName = match
              break
            end
          end

          -- Build the fully qualified class name
          local fullyQualifiedClassName = packageName ~= '' and (packageName .. '.' .. fileNameWithoutExt) or fileNameWithoutExt

          -- Build the commands
          local cmds = {
            'cd ' .. projectRoot,
            'mkdir -p out',
            'find ' .. srcDir .. ' -name "*.java" > sources.txt',
            'javac -d out @sources.txt',
            'rm sources.txt',
            'java -cp out ' .. fullyQualifiedClassName
          }

          -- Return the commands as a single string
          return table.concat(cmds, ' && ')
        end,
        python = "python3 -u",
        typescript = "deno run",
        rust = {
          "cd $dir &&",
          "rustc $fileName &&",
          "$dir/$fileNameWithoutExt"
        },
        c = function(...)
          local c_base = {
            "cd $dir &&",
            "gcc $fileName -o",
            "/tmp/$fileNameWithoutExt",
          }
          local c_exec = {
            "&& /tmp/$fileNameWithoutExt &&",
            "rm /tmp/$fileNameWithoutExt",
          }
          vim.ui.input({ prompt = "Add more args:" }, function(input)
            c_base[4] = input
            require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
          end)
        end,
      },
    })
  end,
}
