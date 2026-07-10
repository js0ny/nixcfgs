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

---@return string
local function imgpath()
  local img = swayimg.viewer.get_image()
  local escaped_path = utils.shell_quote(img.path)
  return escaped_path
end

local slideshow_map = {
  ['q'] = function()
    swayimg.exit(0)
  end,
  ['Ctrl-C'] = function()
    local escaped_path = imgpath()
    local cmd = string.format('cat %s | wl-copy', escaped_path)
    os.execute(cmd)
    os.execute(
      string.format("notify-send -t 1100 -u low -r 3301 'swayimg' 'Image copied to clipboard'")
    )
  end,
  -- Copy path
  ['Ctrl-Shift-C'] = function()
    local escaped_path = imgpath()
    local cmd = string.format('echo %s | wl-copy', escaped_path)
    os.execute(cmd)
  end,
  -- Edit with satty
  ['e'] = function()
    local path = imgpath()
    os.execute('satty --filename ' .. path)
  end,
  ['f'] = function()
    swayimg.set_fullscreen()
  end,
  ['Return'] = function()
    swayimg.set_mode('viewer')
  end,
  ['Alt-Return'] = function()
    utils.show_properties(swayimg.slideshow.get_image())
  end,
  ['t'] = function()
    swayimg.set_mode('gallery')
  end,
  ['s'] = function()
    swayimg.set_mode('viewer')
  end,
  ['n'] = function()
    swayimg.slideshow.switch_image('next')
  end,
  ['p'] = function()
    swayimg.slideshow.switch_image('prev')
  end,
}

for key, value in pairs(slideshow_map) do
  swayimg.slideshow.on_key(key, value)
end
