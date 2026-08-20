-- Floating, movable keymap reference panel, meant to stay open in the
-- background for reference while you code.
--
-- <leader>?  from your code: opens the panel (or jumps focus into it if
--            it's already open in the background). From inside the
--            panel: jumps focus back to the code window you came from,
--            WITHOUT closing the panel.
--
-- While the panel is focused:
--   Tab / S-Tab   cycle tabs
--   j / k         scroll within a tab
--   H J K L       move the window
--   + / -         resize height
--   < / >         resize width
--   m             minimize / restore
--   M             maximize / restore
--   c             cycle corner-docked "small square" presets
--   q / Esc       fully close the panel (back to <leader>? to reopen)
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
  width = 72,
  height = 20,
  mode = "normal", -- normal | minimized | maximized | docked
  saved = nil, -- {row, col, width, height, mode} to restore from minimize/maximize/dock
  corner_idx = 1,
  prev_mouse_opt = nil,
  drag = nil,
  prev_win = nil, -- window to return focus to when jumping back to code
}

local FOOTER = "q close   <leader>? back to code   Tab/S-Tab tabs   H/J/K/L move   m/M/c size"

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

-- Packs all tab labels into as many lines as needed to fit max_w, so every
-- tab stays visible instead of being cut off on one unwrapped line.
local function build_tabline_lines(labels, max_w)
  local tabline_lines = {}
  local cur = ""
  for _, label in ipairs(labels) do
    local candidate = (cur == "") and label or (cur .. " " .. label)
    if #candidate > max_w and cur ~= "" then
      table.insert(tabline_lines, cur)
      cur = label
    else
      cur = candidate
    end
  end
  if cur ~= "" then table.insert(tabline_lines, cur) end
  return tabline_lines
end

local function render()
  if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then return end

  vim.api.nvim_buf_set_option(state.buf, "modifiable", true)
  vim.api.nvim_buf_clear_namespace(state.buf, NS, 0, -1)

  if state.mode == "minimized" then
    local lines = { string.format("Keymaps (%d/%d) - press m to restore", state.current_tab, #tabs) }
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(state.buf, "modifiable", false)
    return
  end

  local labels = {}
  for i, tab in ipairs(tabs) do
    labels[i] = string.format("[%d]%s", i, tab.title)
  end
  local max_w = math.max(10, state.width - 2)
  local tabline_lines = build_tabline_lines(labels, max_w)

  local lines = {}
  for _, l in ipairs(tabline_lines) do
    table.insert(lines, l)
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

  -- reserved: tabline rows + blank separator + footer line
  local reserved = #tabline_lines + 1 + 1
  local visible_rows = math.max(1, state.height - reserved)
  local max_scroll = math.max(0, #body - visible_rows)
  state.scroll = clamp(state.scroll, 0, max_scroll)

  for i = state.scroll + 1, math.min(#body, state.scroll + visible_rows) do
    table.insert(lines, body[i])
  end

  table.insert(lines, FOOTER)

  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)

  -- Highlight the active tab label, wherever it landed in the wrapped tabline.
  for row_idx, row_text in ipairs(tabline_lines) do
    local s, e = string.find(row_text, labels[state.current_tab], 1, true)
    if s then
      vim.api.nvim_buf_add_highlight(state.buf, NS, "PmenuSel", row_idx - 1, s - 1, e)
      break
    end
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
  local return_to = state.prev_win
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  if state.prev_mouse_opt ~= nil then
    vim.o.mouse = state.prev_mouse_opt
    state.prev_mouse_opt = nil
  end
  state.win = nil
  if return_to and vim.api.nvim_win_is_valid(return_to) then
    vim.api.nvim_set_current_win(return_to)
  end
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
    local cur_win = vim.api.nvim_get_current_win()
    if cur_win == state.win then
      -- Already in the panel: jump back to the code we came from, leaving
      -- the panel open in the background.
      if state.prev_win and vim.api.nvim_win_is_valid(state.prev_win) then
        vim.api.nvim_set_current_win(state.prev_win)
      end
    else
      -- Panel is open in the background: jump into it.
      state.prev_win = cur_win
      vim.api.nvim_set_current_win(state.win)
    end
  else
    state.prev_win = vim.api.nvim_get_current_win()
    open()
  end
end

vim.keymap.set("n", "<leader>?", M.toggle, { desc = "Toggle keymap panel", silent = true })

return M
