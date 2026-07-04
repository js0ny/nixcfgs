local utils = require("utils")

---@return { width: integer, height: integer }
---@return { x: integer, y: integer }
local function getpos()
  return swayimg.get_window_size(), swayimg.viewer.get_position()
end

---@param op function
---@return function
local function move_horizontal(op)
  return function()
    local wnd, pos = getpos()
    swayimg.viewer.set_abs_position(math.floor(op(pos.x, wnd.width / 10)), pos.y)
  end
end

---@param op function
---@return function
local function move_vertical(op)
  return function()
    local wnd, pos = getpos()
    swayimg.viewer.set_abs_position(pos.x, math.floor(op(pos.y, wnd.height / 10)))
  end
end

---@return string
local function imgpath()
  local img = swayimg.viewer.get_image()
  local escaped_path = "'" .. img.path:gsub("'", "'\\''") .. "'"
  return escaped_path
end

local viewer_map = {
  ["Left"] = move_horizontal(utils.add),
  ["h"] = move_horizontal(utils.add),
  ["Down"] = move_vertical(utils.sub),
  ["j"] = move_vertical(utils.sub),
  ["Up"] = move_vertical(utils.add),
  ["k"] = move_vertical(utils.add),
  ["Right"] = move_horizontal(utils.sub),
  ["l"] = move_horizontal(utils.sub),
  ["n"] = function()
    swayimg.viewer.switch_image("next")
  end,
  ["p"] = function()
    swayimg.viewer.switch_image("prev")
  end,
  ["z"] = function()
    swayimg.viewer.reset()
  end,
  ["q"] = function()
    swayimg.exit(0)
  end,
  ["Ctrl-C"] = function()
    local escaped_path = imgpath()
    local cmd = string.format("cat %s | wl-copy", escaped_path)
    os.execute(cmd)
    os.execute(string.format("notify-send -t 1100 -u low -r 3301 'swayimg' 'Image copied to clipboard'"))
  end,
  -- Copy path
  ["Ctrl-Shift-C"] = function()
    local escaped_path = imgpath()
    local cmd = string.format("echo %s | wl-copy", escaped_path)
    os.execute(cmd)
  end,
  ["r"] = function()
    swayimg.viewer.rotate(90)
  end,
  ["Shift-r"] = function()
    swayimg.viewer.rotate(270)
  end,
  -- Edit with satty
  ["e"] = function()
    local path = imgpath()
    os.execute("satty --filename " .. path)
  end,
  ["f"] = function()
    swayimg.set_fullscreen()
  end,
  ["Return"] = function()
    swayimg.set_mode("gallery")
  end,
  -- thumbnail mode | gallery
  ["t"] = function()
    swayimg.set_mode("gallery")
  end,
  ["s"] = function()
    swayimg.set_mode("slideshow")
  end,
  ["Shift-w"] = function()
    local escaped_path = imgpath()
    os.execute("setwall " .. escaped_path)
    os.execute(string.format("notify-send -t 1100 -u low -r 3301 'swayimg' 'wallpaper set'"))
  end,
}

for key, value in pairs(viewer_map) do
  swayimg.viewer.on_key(key, value)
end
