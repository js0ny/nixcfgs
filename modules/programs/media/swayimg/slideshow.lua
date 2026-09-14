local utils = require('utils')

---@return { width: integer, height: integer }
---@return { x: integer, y: integer }
local function getpos()
  return swayimg.get_window_size(), swayimg.slideshow.get_position()
end

---@param op function
---@return function
local function move_horizontal(op)
  return function()
    local wnd, pos = getpos()
    swayimg.slideshow.set_abs_position(math.floor(op(pos.x, wnd.width / 10)), pos.y)
  end
end

---@param op function
---@return function
local function move_vertical(op)
  return function()
    local wnd, pos = getpos()
    swayimg.slideshow.set_abs_position(pos.x, math.floor(op(pos.y, wnd.height / 10)))
  end
end

---@return string|nil
local function imgpath()
  local img = swayimg.slideshow.get_image()
  if not img then
    return nil
  end

  return utils.shell_quote(img.path)
end

local slideshow_map = {
  ['q'] = function()
    swayimg.exit(0)
  end,
  ['Ctrl-C'] = function()
    local escaped_path = imgpath()
    if not escaped_path then
      return
    end

    local cmd = string.format('cat %s | wl-copy', escaped_path)
    os.execute(cmd)
    os.execute(
      string.format("notify-send -t 1100 -u low -r 3301 'swayimg' 'Image copied to clipboard'")
    )
  end,
  -- Copy path
  ['Ctrl-Shift-C'] = function()
    local escaped_path = imgpath()
    if not escaped_path then
      return
    end

    local cmd = string.format('echo %s | wl-copy', escaped_path)
    os.execute(cmd)
  end,
  -- Edit with satty
  ['e'] = function()
    local path = imgpath()
    if not path then
      return
    end

    os.execute('satty --filename ' .. path)
  end,
  ['f'] = function()
    swayimg.fullscreen = not swayimg.fullscreen
  end,
  ['Return'] = function()
    swayimg.mode = 'viewer'
  end,
  ['Alt-Return'] = function()
    utils.show_properties(swayimg.slideshow.get_image())
  end,
  ['t'] = function()
    swayimg.mode = 'gallery'
  end,
  ['s'] = function()
    swayimg.mode = 'viewer'
  end,
  ['n'] = function()
    swayimg.slideshow.open('next')
  end,
  ['p'] = function()
    swayimg.slideshow.open('prev')
  end,
}

for key, value in pairs(slideshow_map) do
  swayimg.slideshow.on_key(key, value)
end
