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

M.toggle_focus_float = function()
  local win = hl.get_active_window()
  if not win then
    return
  end

  if win.floating then
    hl.dispatch(hl.dsp.window.cycle_next({ tiled = true }))
  else
    hl.dispatch(hl.dsp.window.cycle_next({ floating = true }))
  end
end

M.layout_cycle = function()
  local layouts = { 'scrolling', 'dwindle', 'master', 'monocle' }
  local workspace = hl.get_active_workspace()
  if hl.get_active_special_workspace() then
    workspace = hl.get_active_special_workspace()
  end

  local next_layout = 'dwindle'

  if not workspace then
    return
  end

  for i = 1, #layouts do
    if layouts[i] == workspace.tiled_layout then
      local next_layout_idx = (i % #layouts) + 1
      next_layout = layouts[next_layout_idx]
      break
    end
  end

  M.notify('Layout ' .. next_layout)

  if workspace.special then
    hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout })
  else
    hl.workspace_rule({ workspace = tostring(workspace.id), layout = next_layout })
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

return M
