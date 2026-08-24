# Neovim Cheatsheet

Leader key: **SPACE**

## Vim Basics (no leader needed)

| Key | Mode | Action |
|-----|------|--------|
| `i` | Normal | Enter Insert mode (type text) |
| `Esc` | Insert | Back to Normal mode |
| `h j k l` | Normal | Move left/down/up/right |
| `w` | Normal | Jump forward one word |
| `b` | Normal | Jump backward one word |
| `gg` | Normal | Go to top of file |
| `G` | Normal | Go to bottom of file |
| `Ctrl+d` | Normal | Scroll half page down |
| `Ctrl+u` | Normal | Scroll half page up |
| `0` | Normal | Go to start of line |
| `$` | Normal | Go to end of line |
| `:{number}` | Normal | Go to line number |

## Editing Basics

| Key | Mode | Action |
|-----|------|--------|
| `dd` | Normal | Delete (cut) entire line |
| `yy` | Normal | Copy (yank) entire line |
| `p` | Normal | Paste below |
| `P` | Normal | Paste above |
| `u` | Normal | Undo |
| `Ctrl+r` | Normal | Redo |
| `x` | Normal | Delete character under cursor |
| `A` | Normal | Insert at end of line |
| `o` | Normal | New line below and insert |
| `O` | Normal | New line above and insert |
| `ciw` | Normal | Change inner word (delete word + insert) |
| `diw` | Normal | Delete inner word |

## Search & Replace

| Key | Mode | Action |
|-----|------|--------|
| `/word` | Normal | Search forward for "word" |
| `?word` | Normal | Search backward for "word" |
| `n` | Normal | Next search result |
| `N` | Normal | Previous search result |
| `:%s/old/new/g` | Command | Replace all "old" with "new" in file |
| `:%s/old/new/gc` | Command | Replace all with confirmation |
| `*` | Normal | Search word under cursor |

## File & Save (SPACE + ...)

| Key | Action |
|-----|--------|
| `SPACE ww` | Save file |
| `SPACE wq` | Save and quit |
| `SPACE qq` | Quit without saving |

## File Explorer (nvim-tree)

| Key | Action |
|-----|--------|
| `SPACE ee` | Toggle file explorer |
| `SPACE er` | Focus file explorer |
| `SPACE ef` | Find current file in explorer |

## Find Files (Telescope)

| Key | Action |
|-----|--------|
| `SPACE ff` | Find files by name |
| `SPACE fg` | Search text in all files (live grep) |
| `SPACE fb` | Search open buffers |
| `SPACE fs` | Search inside current file |

## Code Navigation (LSP)

| Key | Action |
|-----|--------|
| `SPACE gd` | Go to definition |
| `SPACE gD` | Go to declaration |
| `SPACE gI` | Go to implementation |
| `SPACE gt` | Go to type definition |
| `SPACE gr` | Find all references |
| `K` | Hover info (show docs) |
| `Ctrl+o` | Jump back (after go-to-definition) |
| `Ctrl+i` | Jump forward |

## Code Editing (LSP)

| Key | Action |
|-----|--------|
| `SPACE rr` | Rename symbol everywhere |
| `SPACE ga` | Code action (quick fix) |
| `SPACE gf` | Format document |
| `SPACE f` | Format with Prettier |
| `SPACE gl` | Show error in popup |
| `SPACE gn` | Next error/warning |
| `SPACE gp` | Previous error/warning |
| `gc` + motion | Comment/uncomment (e.g. `gcc` for line) |

## Autocomplete (Insert mode)

| Key | Action |
|-----|--------|
| `Ctrl+Space` | Show suggestions |
| `Ctrl+j` | Next suggestion |
| `Ctrl+k` | Previous suggestion |
| `Enter` | Confirm selection |
| `Tab` | Next suggestion / expand snippet |
| `Shift+Tab` | Previous suggestion |

## Quick File Marks (Harpoon)

| Key | Action |
|-----|--------|
| `SPACE ha` | Mark current file |
| `SPACE hh` | Show marked files |
| `SPACE h1`..`h9` | Jump to marked file 1-9 |

## Windows & Tabs

| Key | Action |
|-----|--------|
| `SPACE sv` | Split vertically |
| `SPACE sh` | Split horizontally |
| `SPACE sx` | Close split |
| `SPACE h/j/k/l` | Navigate between splits |
| `SPACE sm` | Maximize/restore split |
| `SPACE to` | New tab |
| `SPACE tx` | Close tab |
| `SPACE tn` | Next tab |
| `SPACE tp` | Previous tab |

## Git

| Key | Action |
|-----|--------|
| `SPACE gb` | Toggle git blame |

## Surround (nvim-surround)

| Key | Action |
|-----|--------|
| `ys{motion}{char}` | Add surround (e.g. `ysiw"` wraps word in `"`) |
| `cs{old}{new}` | Change surround (e.g. `cs"'` changes `"` to `'`) |
| `ds{char}` | Delete surround (e.g. `ds"` removes `"`) |

## Tmux (prefix: Ctrl+a)

Press `Ctrl+a` first, then the key.

| Key | Action |
|-----|--------|
| `Ctrl+a \|` | Split pane vertically (side by side) |
| `Ctrl+a -` | Split pane horizontally (top/bottom) |
| `Ctrl+a x` | Close current pane |
| `Ctrl+a z` | Zoom/unzoom current pane (fullscreen) |
| `Ctrl+a c` | Create new window |
| `Ctrl+a n` | Next window |
| `Ctrl+a p` | Previous window |
| `Ctrl+a {number}` | Switch to window number |
| `Ctrl+a ,` | Rename current window |
| `Ctrl+a d` | Detach from session |
| `Ctrl+a r` | Reload tmux config |
| `Ctrl+a [` | Enter scroll/copy mode (q to exit) |

**Navigate between panes (no prefix needed):**

| Key | Action |
|-----|--------|
| `Ctrl+h` | Move to left pane |
| `Ctrl+j` | Move to pane below |
| `Ctrl+k` | Move to pane above |
| `Ctrl+l` | Move to right pane |

These also work to move between Neovim splits and tmux panes seamlessly
(vim-tmux-navigator).

**Tmux from the terminal:**

| Command | Action |
|---------|--------|
| `tmux` | Start new session |
| `tmux new -s name` | Start named session |
| `tmux ls` | List sessions |
| `tmux a -t name` | Attach to named session |
| `tmux kill-session -t name` | Kill a session |

## Tips

- `SPACE gd` to jump into a definition, then `Ctrl+o` to come back.
  Press `Ctrl+o` multiple times to keep going back.
- `Ctrl+h/j/k/l` moves between Neovim splits AND tmux panes seamlessly.
- Mouse is enabled in tmux -- you can click panes, scroll, and resize.
