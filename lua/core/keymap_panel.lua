-- Floating, movable keymap reference panel.
-- Toggle: <leader>?
-- While the panel is focused:
--   Tab / S-Tab   cycle tabs
--   j / k         scroll within a tab
--   H J K L       move the window
--   + / -         resize height
--   < / >         resize width
--   m             minimize / restore
--   M             maximize / restore
--   c             cycle corner-docked "small square" presets
--   q / Esc       close
--   drag the top (title) row with the mouse to move

local tabs = require("core.keymap_data")

local M = {}

local NS = vim.api.nvim_create_namespace("keymap_panel")

local state = {
  win = nil,
  buf = nil,
  current_tab = 1,
  scroll = 0,
  row = 2,
  col = 2,
  width = 60,
  height = 18,
  mode = "normal", -- normal | minimized | maximized | docked
  saved = nil, -- {row, col, width, height, mode} to restore from minimize/maximize/dock
  corner_idx = 1,
  prev_mouse_opt = nil,
  drag = nil,
}

local CORNERS = { "top-left", "top-right", "bottom-left", "bottom-right" }
local DOCK_SIZE = { width = 22, height = 8 }
local MARGIN = 1

local function clamp(v, lo, hi)
  if hi < lo then return lo end
  return math.max(lo, math.min(hi, v))
end

local function editor_size()
  return vim.o.columns, vim.o.lines - vim.o.cmdheight
end

local function clamp_position()
  local cols, lines = editor_size()
  state.width = clamp(state.width, 10, cols - 2)
  state.height = clamp(state.height, 1, lines - 2)
  state.row = clamp(state.row, 0, lines - state.height - 1)
  state.col = clamp(state.col, 0, cols - state.width - 1)
end

local function corner_position(name, width, height)
  local cols, lines = editor_size()
  if name == "top-left" then
    return MARGIN, MARGIN
  elseif name == "top-right" then
    return MARGIN, cols - width - MARGIN
  elseif name == "bottom-left" then
    return lines - height - MARGIN, MARGIN
  else -- bottom-right
    return lines - height - MARGIN, cols - width - MARGIN
  end
end

local function win_config()
  return {
    relative = "editor",
    row = state.row,
    col = state.col,
    width = state.width,
    height = state.height,
    style = "minimal",
    border = "rounded",
    title = " Keymaps ",
    title_pos = "center",
    zindex = 200,
  }
end

local function render()
  if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then return end

  vim.api.nvim_buf_set_option(state.buf, "modifiable", true)
  vim.api.nvim_buf_clear_namespace(state.buf, NS, 0, -1)

  local lines = {}
  local tabline_parts = {}
  for i, tab in ipairs(tabs) do
    table.insert(tabline_parts, string.format("[%d]%s", i, tab.title))
  end
  local tabline = table.concat(tabline_parts, " ")
  table.insert(lines, tabline)

  if state.mode == "minimized" then
    lines = { string.format("Keymaps (%d/%d) - press m to restore", state.current_tab, #tabs) }
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(state.buf, "modifiable", false)
    return
  end

  table.insert(lines, "")

  local tab = tabs[state.current_tab]
  local key_width = 0
  for _, entry in ipairs(tab.entries) do
    key_width = math.max(key_width, #entry.key)
  end

  local body = {}
  for _, entry in ipairs(tab.entries) do
    table.insert(body, string.format("%-" .. key_width .. "s  %s", entry.key, entry.action))
  end

  local visible_rows = math.max(1, state.height - 2)
  local max_scroll = math.max(0, #body - visible_rows)
  state.scroll = clamp(state.scroll, 0, max_scroll)

  for i = state.scroll + 1, math.min(#body, state.scroll + visible_rows) do
    table.insert(lines, body[i])
  end

  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)

  -- Highlight the active tab label on the tabline.
  local start_col = 0
  for i, part in ipairs(tabline_parts) do
    if i == state.current_tab then
      vim.api.nvim_buf_add_highlight(state.buf, NS, "PmenuSel", 0, start_col, start_col + #part)
      break
    end
    start_col = start_col + #part + 1
  end

  vim.api.nvim_buf_set_option(state.buf, "modifiable", false)
end

local function apply_win_config()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_set_config(state.win, win_config())
  end
end

local function move(dr, dc)
  state.row = state.row + dr
  state.col = state.col + dc
  clamp_position()
  apply_win_config()
end

local function resize(dw, dh)
  state.width = state.width + dw
  state.height = state.height + dh
  clamp_position()
  apply_win_config()
  render()
end

local function next_tab(delta)
  state.current_tab = ((state.current_tab - 1 + delta) % #tabs) + 1
  state.scroll = 0
  render()
end

local function scroll(delta)
  state.scroll = state.scroll + delta
  render()
end

local function save_snapshot()
  state.saved = { row = state.row, col = state.col, width = state.width, height = state.height }
end

local function restore_snapshot()
  if state.saved then
    state.row, state.col, state.width, state.height =
      state.saved.row, state.saved.col, state.saved.width, state.saved.height
    state.saved = nil
  end
end

local function toggle_minimize()
  if state.mode == "minimized" then
    state.mode = "normal"
    restore_snapshot()
  else
    save_snapshot()
    state.mode = "minimized"
    state.height = 1
    state.width = 30
    state.row, state.col = corner_position("bottom-right", state.width, state.height)
  end
  clamp_position()
  apply_win_config()
  render()
end

local function toggle_maximize()
  if state.mode == "maximized" then
    state.mode = "normal"
    restore_snapshot()
  else
    save_snapshot()
    state.mode = "maximized"
    local cols, lines = editor_size()
    state.row, state.col = MARGIN, MARGIN
    state.width, state.height = cols - 2 * MARGIN - 2, lines - 2 * MARGIN - 2
  end
  clamp_position()
  apply_win_config()
  render()
end

local function cycle_dock()
  state.mode = "docked"
  state.width, state.height = DOCK_SIZE.width, DOCK_SIZE.height
  state.corner_idx = (state.corner_idx % #CORNERS) + 1
  state.row, state.col = corner_position(CORNERS[state.corner_idx], state.width, state.height)
  clamp_position()
  apply_win_config()
  render()
end

local function start_drag()
  local mp = vim.fn.getmousepos()
  if mp.winid ~= state.win or mp.line ~= 1 then return end
  state.drag = { screenrow = mp.screenrow, screencol = mp.screencol, row = state.row, col = state.col }
end

local function do_drag()
  if not state.drag then return end
  local mp = vim.fn.getmousepos()
  state.row = state.drag.row + (mp.screenrow - state.drag.screenrow)
  state.col = state.drag.col + (mp.screencol - state.drag.screencol)
  clamp_position()
  apply_win_config()
end

local function end_drag()
  state.drag = nil
end

function M.close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  if state.prev_mouse_opt ~= nil then
    vim.o.mouse = state.prev_mouse_opt
    state.prev_mouse_opt = nil
  end
  state.win = nil
end

local function setup_keymaps(buf)
  local opts = { buffer = buf, nowait = true, silent = true }
  vim.keymap.set("n", "q", M.close, opts)
  vim.keymap.set("n", "<Esc>", M.close, opts)
  vim.keymap.set("n", "<Tab>", function() next_tab(1) end, opts)
  vim.keymap.set("n", "<S-Tab>", function() next_tab(-1) end, opts)
  vim.keymap.set("n", "j", function() scroll(1) end, opts)
  vim.keymap.set("n", "k", function() scroll(-1) end, opts)
  vim.keymap.set("n", "H", function() move(0, -2) end, opts)
  vim.keymap.set("n", "J", function() move(1, 0) end, opts)
  vim.keymap.set("n", "K", function() move(-1, 0) end, opts)
  vim.keymap.set("n", "L", function() move(0, 2) end, opts)
  vim.keymap.set("n", "<Left>", function() move(0, -2) end, opts)
  vim.keymap.set("n", "<Down>", function() move(1, 0) end, opts)
  vim.keymap.set("n", "<Up>", function() move(-1, 0) end, opts)
  vim.keymap.set("n", "<Right>", function() move(0, 2) end, opts)
  vim.keymap.set("n", "+", function() resize(0, 1) end, opts)
  vim.keymap.set("n", "-", function() resize(0, -1) end, opts)
  vim.keymap.set("n", "<", function() resize(-2, 0) end, opts)
  vim.keymap.set("n", ">", function() resize(2, 0) end, opts)
  vim.keymap.set("n", "m", toggle_minimize, opts)
  vim.keymap.set("n", "M", toggle_maximize, opts)
  vim.keymap.set("n", "c", cycle_dock, opts)
  vim.keymap.set("n", "<LeftMouse>", start_drag, opts)
  vim.keymap.set("n", "<LeftDrag>", do_drag, opts)
  vim.keymap.set("n", "<LeftRelease>", end_drag, opts)
end

local function open()
  state.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(state.buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(state.buf, "filetype", "keymap-panel")

  state.mode = "normal"
  clamp_position()
  state.win = vim.api.nvim_open_win(state.buf, true, win_config())

  state.prev_mouse_opt = vim.o.mouse
  vim.o.mouse = "a"

  setup_keymaps(state.buf)
  render()

  vim.api.nvim_create_autocmd("WinClosed", {
    buffer = state.buf,
    once = true,
    callback = function()
      if state.prev_mouse_opt ~= nil then
        vim.o.mouse = state.prev_mouse_opt
        state.prev_mouse_opt = nil
      end
      state.win = nil
    end,
  })
end

function M.toggle()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    M.close()
  else
    open()
  end
end

vim.keymap.set("n", "<leader>?", M.toggle, { desc = "Toggle keymap panel", silent = true })

return M
