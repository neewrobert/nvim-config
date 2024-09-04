# Neovim Keymaps Cheatsheet

## General Keymaps
- **Leader Key**: `<Space>`  
  *The leader key is set to space for easy access.*

- **Save & Quit**: `<leader>wq` → `:wq`  
  *Saves the current file and quits Neovim.*

- **Quit without saving**: `<leader>qq` → `:q!`  
  *Quits Neovim without saving any changes.*

- **Save**: `<leader>ww` → `:w`  
  *Saves the current file.*

- **Open URL under cursor**: `gx` → `:!open <c-r><c-a>`  
  *Opens the URL under the cursor using the default browser.*

## Window Management
- **Vertical Split**: `<leader>sv` → `<C-w>v`  
  *Splits the current window vertically.*

- **Horizontal Split**: `<leader>sh` → `<C-w>s`  
  *Splits the current window horizontally.*

- **Equalize Splits**: `<leader>se` → `<C-w>=`  
  *Makes all split windows equal in size.*

- **Close Split**: `<leader>sx` → `:close`  
  *Closes the current split window.*

- **Adjust Height (Shorter)**: `<leader>sj` → `<C-w>-`  
  *Decreases the height of the current split window.*

- **Adjust Height (Taller)**: `<leader>sk` → `<C-w>+`  
  *Increases the height of the current split window.*

- **Adjust Width (Wider)**: `<leader>sl` → `<C-w>>5`  
  *Increases the width of the current split window.*

- **Adjust Width (Narrower)**: `<leader>sh` → `<C-w><5`  
  *Decreases the width of the current split window.*

## Tab Management
- **New Tab**: `<leader>to` → `:tabnew`  
  *Opens a new tab.*

- **Close Tab**: `<leader>tx` → `:tabclose`  
  *Closes the current tab.*

- **Next Tab**: `<leader>tn` → `:tabn`  
  *Switches to the next tab.*

- **Previous Tab**: `<leader>tp` → `:tabp`  
  *Switches to the previous tab.*

## Diff Keymaps
- **Put Diff**: `<leader>cc` → `:diffput`  
  *Applies changes from the current buffer to the other buffer in diff mode.*

- **Get Diff (Left)**: `<leader>cj` → `:diffget 1`  
  *Gets changes from the left buffer during a diff merge.*

- **Get Diff (Right)**: `<leader>ck` → `:diffget 3`  
  *Gets changes from the right buffer during a diff merge.*

- **Next Diff Hunk**: `<leader>cn` → `]c`  
  *Moves to the next diff hunk.*

- **Previous Diff Hunk**: `<leader>cp` → `[c`  
  *Moves to the previous diff hunk.*

## Quickfix
- **Open Quickfix List**: `<leader>qo` → `:copen`  
  *Opens the quickfix list.*

- **Jump to First**: `<leader>qf` → `:cfirst`  
  *Jumps to the first item in the quickfix list.*

- **Next Item**: `<leader>qn` → `:cnext`  
  *Jumps to the next item in the quickfix list.*

- **Previous Item**: `<leader>qp` → `:cprev`  
  *Jumps to the previous item in the quickfix list.*

- **Last Item**: `<leader>ql` → `:clast`  
  *Jumps to the last item in the quickfix list.*

- **Close Quickfix List**: `<leader>qc` → `:cclose`  
  *Closes the quickfix list.*

## Vim-Maximizer
- **Toggle Maximize Tab**: `<leader>sm` → `:MaximizerToggle`  
  *Toggles maximizing the current window.*

## Nvim-tree
- **Toggle File Explorer**: `<leader>ee` → `:NvimTreeToggle`  
  *Opens or closes the file explorer.*

- **Focus File Explorer**: `<leader>er` → `:NvimTreeFocus`  
  *Moves focus to the file explorer.*

- **Find File in Explorer**: `<leader>ef` → `:NvimTreeFindFile`  
  *Finds the current file in the file explorer.*

## Telescope
- **Find Files**: `<leader>ff` → `:Telescope find_files`  
  *Searches for files in the current project.*

- **Live Grep**: `<leader>fg` → `:Telescope live_grep`  
  *Performs a live grep search across the project.*

- **Buffers**: `<leader>fb` → `:Telescope buffers`  
  *Lists and switches between open buffers.*

- **Help Tags**: `<leader>fh` → `:Telescope help_tags`  
  *Searches for help tags.*

- **Fuzzy Find in Current Buffer**: `<leader>fs` → `:Telescope current_buffer_fuzzy_find`  
  *Fuzzy searches within the current buffer.*

- **Document Symbols**: `<leader>fo` → `:Telescope lsp_document_symbols`  
  *Lists symbols in the current document.*

- **Incoming Calls**: `<leader>fi` → `:Telescope lsp_incoming_calls`  
  *Lists incoming LSP calls.*

- **Treesitter Methods**: `<leader>fm` → `:Telescope treesitter {default_text=":method:"}`  
  *Searches for methods in the current project using Treesitter.*

## Git-Blame
- **Toggle Git Blame**: `<leader>gb` → `:GitBlameToggle`  
  *Toggles git blame annotation.*

## Harpoon
- **Add File**: `<leader>ha` → `require("harpoon.mark").add_file`  
  *Adds the current file to Harpoon's list.*

- **Toggle Quick Menu**: `<leader>hh` → `require("harpoon.ui").toggle_quick_menu`  
  *Opens the Harpoon quick menu.*

- **Navigate Files**:
  - **File 1**: `<leader>h1` → `require("harpoon.ui").nav_file(1)`  
  *Navigates to the first file in Harpoon.*

  - **File 2**: `<leader>h2` → `require("harpoon.ui").nav_file(2)`  
  *Navigates to the second file in Harpoon.*

  - **File 3**: `<leader>h3` → `require("harpoon.ui").nav_file(3)`  
  *Navigates to the third file in Harpoon.*

  - **File 4**: `<leader>h4` → `require("harpoon.ui").nav_file(4)`  
  *Navigates to the fourth file in Harpoon.*

  - **File 5**: `<leader>h5` → `require("harpoon.ui").nav_file(5)`  
  *Navigates to the fifth file in Harpoon.*

  - **File 6**: `<leader>h6` → `require("harpoon.ui").nav_file(6)`  
  *Navigates to the sixth file in Harpoon.*

  - **File 7**: `<leader>h7` → `require("harpoon.ui").nav_file(7)`  
  *Navigates to the seventh file in Harpoon.*

  - **File 8**: `<leader>h8` → `require("harpoon.ui").nav_file(8)`  
  *Navigates to the eighth file in Harpoon.*

  - **File 9**: `<leader>h9` → `require("harpoon.ui").nav_file(9)`  
  *Navigates to the ninth file in Harpoon.*

## Vim REST Console
- **Run REST Query**: `<leader>xr` → `:call VrcQuery()`  
  *Executes a REST query using Vim REST Console.*

## LSP
- **Hover**: `<leader>gg` → `:lua vim.lsp.buf.hover()`  
  *Displays hover information about the symbol under the cursor.*

- **Go to Definition**: `<leader>gd` → `:lua vim.lsp.buf.definition()`  
  *Jumps to the definition of the symbol under the cursor.*

- **Go to Declaration**: `<leader>gD` → `:lua vim.lsp.buf.declaration()`  
  *Jumps to the declaration of the symbol under the cursor.*

- **Go to Implementation**: `<leader>gi` → `:lua vim.lsp.buf.implementation()`  
  *Jumps to the implementation of the symbol under the cursor.*

- **Type Definition**: `<leader>gt` → `:lua vim.lsp.buf.type_definition()`  
  *Jumps to the type definition of the symbol under the cursor.*

- **References**: `<leader>gr` → `:lua vim.lsp.buf.references()`  
  *Lists all references to the symbol under the cursor.*

- **Signature Help**: `<leader>gs` → `:lua vim.lsp.buf.signature_help()`  
  *Displays signature information for the function under the cursor.*

- **Rename**: `<leader>rr` → `:lua vim.lsp.buf.rename()`  
  *Renames all references to the symbol under the cursor.*

- **Format**: `<leader>gf` → `:lua vim.lsp.buf.format({async = true})`  
  *Formats the current buffer.*

- **Code Action**: `<leader>ga` → `:lua vim.lsp.buf.code_action()`  
  *Selects a code action available at the current cursor position.*

- **Open Float**: `<leader>gl` → `:lua vim.diagnostic.open_float()`  
  *Displays a floating window with diagnostic information at the cursor.*

- **Go to Prev Diagnostic**: `<leader>gp` → `:lua vim.diagnostic.goto_prev()`  
  *Jumps to the previous diagnostic.*

- **Go to Next Diagnostic**: `<leader>gn` → `:lua vim.diagnostic.goto_next()`  
  *Jumps to the next diagnostic.*

- **Document Symbol**: `<leader>tr` → `:lua vim.lsp.buf.document_symbol()`  
  *Lists all symbols in the current document.*

- **Completion (Insert Mode)**: `<C-Space>` → `:lua vim.lsp.buf.completion()`  
  *Triggers completion in insert mode.*

## Filetype-Specific (Java)
- **Organize Imports**: `<leader>go` → `require('jdtls').organize_imports()`  
  *Organizes imports in a Java file.*

- **Update Project Config**: `<leader>gu` → `require('jdtls').update_projects_config()`  
  *Updates the project configuration in a Java project.*

- **Test Class**: `<leader>tc` → `require('jdtls').test_class()`  
  *Runs the tests in the current Java class.*

- **Test Nearest Method**: `<leader>tm` → `require('jdtls').test_nearest_method()`  
  *Runs the test for the method nearest to the cursor.*

## Debugging (nvim-dap)
- **Toggle Breakpoint**: `<leader>bb` → `:lua require'dap'.toggle_breakpoint()`  
  *Toggles a breakpoint at the current line.*

- **Conditional Breakpoint**: `<leader>bc` → `:lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))`  
  *Sets a conditional breakpoint.*

- **Log Point**: `<leader>bl` → `:lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))`  
  *Sets a log point to output a message instead of stopping.*

- **Clear Breakpoints**: `<leader>br` → `:lua require'dap'.clear_breakpoints()`  
  *Clears all breakpoints.*

- **List Breakpoints**: `<leader>ba` → `:Telescope dap list_breakpoints`  
  *Lists all breakpoints using Telescope.*

- **Continue**: `<leader>dc` → `:lua require'dap'.continue()`  
  *Continues execution until the next breakpoint.*

- **Step Over**: `<leader>dj` → `:lua require'dap'.step_over()`  
  *Steps over the current line.*

- **Step Into**: `<leader>dk` → `:lua require'dap'.step_into()`  
  *Steps into the function on the current line.*

- **Step Out**: `<leader>do` → `:lua require'dap'.step_out()`  
  *Steps out of the current function.*

- **Disconnect and Close**: `<leader>dd` → `:lua require('dap').disconnect(); require('dapui').close();`  
  *Disconnects the debugger and closes the DAP UI.*

- **Terminate and Close**: `<leader>dt` → `:lua require('dap').terminate(); require('dapui').close();`  
  *Terminates the debugging session and closes the DAP UI.*

- **Toggle REPL**: `<leader>dr` → `:lua require'dap'.repl.toggle()`  
  *Toggles the REPL (Read-Eval-Print Loop) for debugging.*

- **Run Last**: `<leader>dl` → `:lua require'dap'.run_last()`  
  *Re-runs the last debugging session.*

- **Hover**: `<leader>di` → `:lua require "dap.ui.widgets".hover()`  
  *Shows a widget with information about the expression under the cursor.*

- **Centered Float**: `<leader>d?` → `:lua require "dap.ui.widgets".centered_float(widgets.scopes)`  
  *Shows a centered floating window with scopes.*

- **Frames**: `<leader>df` → `:Telescope dap frames`  
  *Lists all frames in the current stack.*

- **DAP Commands**: `<leader>dh` → `:Telescope dap commands`  
  *Lists all available DAP commands.*

---

## Suggestions for Additional Keymaps

1. **Harpoon - Previous and Next File Navigation**:
   - **Next Harpoon File**: Consider adding a mapping for navigating to the next file in the Harpoon list.
   - **Previous Harpoon File**: Similarly, a mapping for navigating to the previous file in the Harpoon list could be useful.

2. **Telescope - More LSP Integration**:
   - **Workspace Symbols**: You might add a mapping to search workspace symbols using Telescope's LSP integration.
   - **Diagnostics**: Adding a Telescope command to search through diagnostics in the current workspace might be helpful.

3. **nvim-dap**:
   - **Pause Execution**: A keymap for pausing the debugger could be useful in certain debugging scenarios.

4. **LSP - Code Lens**:
   - **Refresh Code Lens**: If you use LSP code lenses, a mapping to refresh them might be beneficial.
