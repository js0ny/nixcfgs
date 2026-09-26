local utils = require('utils')

---@return string|nil
local function imgpath()
  local img = swayimg.gallery.get_image()
  if not img then
    return nil
  end

  return utils.shell_quote(img.path)
end

local gallery_map = {
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
    utils.notify('Image copied to clipboard')
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
    utils.show_properties(swayimg.gallery.get_image())
  end,
  ['t'] = function()
    swayimg.mode = 'viewer'
  end,
  ['s'] = function()
    swayimg.mode = 'slideshow'
  end,
  ['n'] = function()
    swayimg.gallery.select('pgdown')
  end,
  ['p'] = function()
    swayimg.gallery.select('pgup')
  end,
  ['h'] = function()
    swayimg.gallery.select('left')
  end,
  ['Left'] = function()
    swayimg.gallery.select('left')
  end,
  ['Down'] = function()
    swayimg.gallery.select('down')
  end,
  ['j'] = function()
    swayimg.gallery.select('down')
  end,
  ['Up'] = function()
    swayimg.gallery.select('up')
  end,
  ['k'] = function()
    swayimg.gallery.select('up')
  end,
  ['Right'] = function()
    swayimg.gallery.select('right')
  end,
  ['l'] = function()
    swayimg.gallery.select('right')
  end,
  ['g'] = function()
    swayimg.gallery.select('first')
  end,
  ['Shift+g'] = function()
    swayimg.gallery.select('last')
  end,
}

for key, value in pairs(gallery_map) do
  swayimg.gallery.on_key(key, value)
end
