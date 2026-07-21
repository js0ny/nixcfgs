local M = {}

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

---@alias Size {[1]: integer, [2]: integer}

---@param ratio number # width / height
---@param height number
---@return Size
M.size_from_h = function(ratio, height)
  return { math.floor(height * ratio + 0.5), height }
end

M.uwsm_exec = function(cmd)
  return hl.dsp.exec_cmd('uwsm app -- ' .. cmd)
end

M.term_exec_float = function(cmd)
  return hl.dsp.exec_cmd('xdg-terminal-exec --app-id=floaterm ' .. cmd)
end

return M
