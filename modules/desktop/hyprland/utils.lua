local M = {}

---@param msg string
M.notify = function(msg)
  os.execute(string.format("notify-send -t 1100 -u low -r 3301 'Hyprland' '%s'", msg))
end

function M.executable_in_path(name)
  local path = os.getenv('PATH') or ''

  for dir in path:gmatch('[^:]+') do
    local full = dir .. '/' .. name
    local f = io.open(full, 'rb')
    if f then
      f:close()
      return full
    end
  end

  return nil
end

---@param w HL.Window
M.is_maximised = function(w)
  if w.layout and w.layout.name == 'scrolling' and w.layout.column then
    local width = w.layout.column.width or 0

    if math.abs(width - 1.0) < 0.001 then
      return true
    else
      return false
    end
  else
    return w.fullscreen == 1
  end
end

M.toggle_maximised = function()
  local w = hl.get_active_window()
  if not w then
    return
  end

  if w.layout and w.layout.name == 'scrolling' and w.layout.column then
    local fs = M.is_maximised(w)
    if fs then
      hl.dispatch(hl.dsp.layout('colresize 0.5'))
    else
      hl.dispatch(hl.dsp.layout('colresize 1'))
    end
    return
  end

  hl.dispatch(hl.dsp.window.fullscreen({
    mode = 'maximized',
    action = 'toggle',
  }))
end

local function overlap_area(a, b)
  local left = math.max(a.at.x, b.at.x)
  local top = math.max(a.at.y, b.at.y)
  local right = math.min(a.at.x + a.size.x, b.at.x + b.size.x)
  local bottom = math.min(a.at.y + a.size.y, b.at.y + b.size.y)

  return math.max(0, right - left) * math.max(0, bottom - top)
end

M.toggle_focus_float = function()
  local win = hl.get_active_window()
  if not win then
    return
  end

  if not win.floating then
    hl.dispatch(hl.dsp.window.cycle_next({ floating = true }))
    return
  end

  local target
  local largest_overlap = 0

  for _, candidate in ipairs(hl.get_workspace_windows(win.workspace)) do
    if not candidate.floating and candidate.visible then
      local overlap = overlap_area(win, candidate)
      if overlap > largest_overlap then
        target = candidate
        largest_overlap = overlap
      end
    end
  end

  if target then
    hl.dispatch(hl.dsp.focus({ window = target }))
  else
    hl.dispatch(hl.dsp.window.cycle_next({ tiled = true }))
  end
end

M.layout_bind = function(bind_table)
  return function()
    local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()

    if not workspace then
      return
    end

    local layout = workspace.tiled_layout

    if bind_table[layout] then
      hl.dispatch(bind_table[layout])
    end
  end
end

---@alias Size {[1]: integer, [2]: integer}

---@param ratio number # width / height
---@param height number
---@return Size
M.size_from_h = function(ratio, height)
  return { math.floor(height * ratio + 0.5), height }
end

---@param ratio number # width / height
---@param width number
---@return Size
M.size_from_w = function(ratio, width)
  return { width, math.floor(width / ratio + 0.5) }
end

M.uwsm_exec = function(cmd)
  return hl.dsp.exec_cmd('uwsm app -- ' .. cmd)
end

M.term_exec = function(cmd)
  return hl.dsp.exec_cmd('xdg-terminal-exec ' .. cmd)
end

M.term_exec_float = function(cmd)
  return hl.dsp.exec_cmd('xdg-terminal-exec --app-id=floaterm ' .. cmd)
end

return M
