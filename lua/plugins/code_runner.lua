-- Configuration for running code based on filetype
return {
  -- https://github.com/CRAG666/code_runner.nvim
  'CRAG666/code_runner.nvim',
  event = 'VeryLazy',  -- Load when needed
  config = function()
    require('code_runner').setup({
      filetype = {
        java = {
          "cd $dir &&",
          "mkdir -p ../out/src &&",  -- Create the out directory if it doesn't exist
          "javac -d ../out/src $fileName &&",  -- Compile the Java file and put the .class files in the out directory
          "java -cp ../out/src $fileNameWithoutExt"  -- Run the compiled class from the out directory
        },
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

