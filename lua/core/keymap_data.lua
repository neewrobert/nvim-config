-- Structured keymap reference data for the floating keymap panel
-- (lua/core/keymap_panel.lua). Kept separate from CHEATSHEET.md, which
-- remains the hand-written prose version of the same information.

return {
  {
    title = "Vim Basics",
    entries = {
      { key = "i", action = "Enter Insert mode" },
      { key = "Esc", action = "Back to Normal mode" },
      { key = "h j k l", action = "Move left/down/up/right" },
      { key = "w", action = "Jump forward one word" },
      { key = "b", action = "Jump backward one word" },
      { key = "gg", action = "Go to top of file" },
      { key = "G", action = "Go to bottom of file" },
      { key = "Ctrl+d", action = "Scroll half page down" },
      { key = "Ctrl+u", action = "Scroll half page up" },
      { key = "0", action = "Go to start of line" },
      { key = "$", action = "Go to end of line" },
      { key = ":{number}", action = "Go to line number" },
    },
  },
  {
    title = "Editing Basics",
    entries = {
      { key = "dd", action = "Delete (cut) entire line" },
      { key = "yy", action = "Copy (yank) entire line" },
      { key = "p", action = "Paste below" },
      { key = "P", action = "Paste above" },
      { key = "u", action = "Undo" },
      { key = "Ctrl+r", action = "Redo" },
      { key = "x", action = "Delete character under cursor" },
      { key = "A", action = "Insert at end of line" },
      { key = "o", action = "New line below and insert" },
      { key = "O", action = "New line above and insert" },
      { key = "ciw", action = "Change inner word" },
      { key = "diw", action = "Delete inner word" },
    },
  },
  {
    title = "Search & Replace",
    entries = {
      { key = "/word", action = 'Search forward for "word"' },
      { key = "?word", action = 'Search backward for "word"' },
      { key = "n", action = "Next search result" },
      { key = "N", action = "Previous search result" },
      { key = ":%s/old/new/g", action = 'Replace all "old" with "new"' },
      { key = ":%s/old/new/gc", action = "Replace all with confirmation" },
      { key = "*", action = "Search word under cursor" },
    },
  },
  {
    title = "File & Save",
    entries = {
      { key = "SPACE ww", action = "Save file" },
      { key = "SPACE wq", action = "Save and quit" },
      { key = "SPACE qq", action = "Quit without saving" },
    },
  },
  {
    title = "File Explorer",
    entries = {
      { key = "SPACE ee", action = "Toggle file explorer" },
      { key = "SPACE er", action = "Focus file explorer" },
      { key = "SPACE ef", action = "Find current file in explorer" },
    },
  },
  {
    title = "Telescope",
    entries = {
      { key = "SPACE ff", action = "Find files by name" },
      { key = "SPACE fg", action = "Search text in all files (live grep)" },
      { key = "SPACE fb", action = "Search open buffers" },
      { key = "SPACE fh", action = "Search help tags" },
      { key = "SPACE fs", action = "Search inside current file" },
      { key = "SPACE fo", action = "LSP document symbols" },
      { key = "SPACE fi", action = "LSP incoming calls" },
      { key = "SPACE fm", action = "Treesitter method search" },
    },
  },
  {
    title = "LSP: Navigation",
    entries = {
      { key = "SPACE gd", action = "Go to definition" },
      { key = "SPACE gD", action = "Go to declaration" },
      { key = "SPACE gI", action = "Go to implementation" },
      { key = "SPACE gt", action = "Go to type definition" },
      { key = "SPACE gr", action = "Find all references" },
      { key = "K", action = "Hover info (show docs)" },
      { key = "Ctrl+o", action = "Jump back (after go-to-definition)" },
      { key = "Ctrl+i", action = "Jump forward" },
    },
  },
  {
    title = "LSP: Editing",
    entries = {
      { key = "SPACE rr", action = "Rename symbol everywhere" },
      { key = "SPACE ga", action = "Code action (quick fix)" },
      { key = "SPACE gf", action = "Format document" },
      { key = "SPACE f", action = "Format with Prettier" },
      { key = "SPACE gl", action = "Show error in popup" },
      { key = "SPACE gn", action = "Next error/warning" },
      { key = "SPACE gp", action = "Previous error/warning" },
      { key = "gc + motion", action = "Comment/uncomment (e.g. gcc for line)" },
    },
  },
  {
    title = "Autocomplete",
    entries = {
      { key = "Ctrl+Space", action = "Show suggestions" },
      { key = "Ctrl+j", action = "Next suggestion" },
      { key = "Ctrl+k", action = "Previous suggestion" },
      { key = "Enter", action = "Confirm selection" },
      { key = "Tab", action = "Next suggestion / expand snippet" },
      { key = "Shift+Tab", action = "Previous suggestion" },
    },
  },
  {
    title = "Harpoon",
    entries = {
      { key = "SPACE ha", action = "Mark current file" },
      { key = "SPACE hh", action = "Show marked files" },
      { key = "SPACE h1..h9", action = "Jump to marked file 1-9" },
    },
  },
  {
    title = "Windows & Tabs",
    entries = {
      { key = "SPACE sv", action = "Split vertically" },
      { key = "SPACE sh", action = "Split horizontally" },
      { key = "SPACE sx", action = "Close split" },
      { key = "SPACE h/j/k/l", action = "Navigate between splits" },
      { key = "SPACE sm", action = "Maximize/restore split" },
      { key = "SPACE to", action = "New tab" },
      { key = "SPACE tx", action = "Close tab" },
      { key = "SPACE tn", action = "Next tab" },
      { key = "SPACE tp", action = "Previous tab" },
    },
  },
  {
    title = "Git",
    entries = {
      { key = "SPACE gb", action = "Toggle git blame" },
    },
  },
  {
    title = "Surround",
    entries = {
      { key = 'ys{motion}{char}', action = 'Add surround (e.g. ysiw" wraps word)' },
      { key = "cs{old}{new}", action = 'Change surround (e.g. cs"\' )' },
      { key = "ds{char}", action = 'Delete surround (e.g. ds")' },
    },
  },
  {
    title = "Tmux",
    entries = {
      { key = "Ctrl+a |", action = "Split pane vertically" },
      { key = "Ctrl+a -", action = "Split pane horizontally" },
      { key = "Ctrl+a x", action = "Close current pane" },
      { key = "Ctrl+a z", action = "Zoom/unzoom current pane" },
      { key = "Ctrl+a c", action = "Create new window" },
      { key = "Ctrl+a n", action = "Next window" },
      { key = "Ctrl+a p", action = "Previous window" },
      { key = "Ctrl+a {n}", action = "Switch to window number" },
      { key = "Ctrl+a ,", action = "Rename current window" },
      { key = "Ctrl+a d", action = "Detach from session" },
      { key = "Ctrl+a r", action = "Reload tmux config" },
      { key = "Ctrl+a [", action = "Enter scroll/copy mode (q to exit)" },
      { key = "Ctrl+h/j/k/l", action = "Move between panes/splits (no prefix)" },
    },
  },
}
