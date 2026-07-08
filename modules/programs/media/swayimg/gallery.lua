local utils = require('utils')

---@return string
local function imgpath()
  local img = swayimg.gallery.get_image()
  local escaped_path = utils.shell_quote(img.path)
  return escaped_path
end

local gallery_map = {
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
    utils.show_properties(swayimg.gallery.get_image())
  end,
  ['t'] = function()
    swayimg.set_mode('viewer')
  end,
  ['s'] = function()
    swayimg.set_mode('slideshow')
  end,
  ['n'] = function()
    swayimg.gallery.switch_image('pgdown')
  end,
  ['p'] = function()
    swayimg.gallery.switch_image('pgup')
  end,
  ['h'] = function()
    swayimg.gallery.switch_image('left')
  end,
  ['Left'] = function()
    swayimg.gallery.switch_image('left')
  end,
  ['Down'] = function()
    swayimg.gallery.switch_image('down')
  end,
  ['j'] = function()
    swayimg.gallery.switch_image('down')
  end,
  ['Up'] = function()
    swayimg.gallery.switch_image('up')
  end,
  ['k'] = function()
    swayimg.gallery.switch_image('up')
  end,
  ['Right'] = function()
    swayimg.gallery.switch_image('right')
  end,
  ['l'] = function()
    swayimg.gallery.switch_image('right')
  end,
  ['g'] = function()
    swayimg.gallery.switch_image('first')
  end,
  ['G'] = function()
    swayimg.gallery.switch_image('last')
  end,
}

for key, value in pairs(gallery_map) do
  swayimg.gallery.on_key(key, value)
end
