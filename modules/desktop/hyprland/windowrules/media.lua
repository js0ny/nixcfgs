local utils = require('utils')

hl.window_rule({
  name = 'firefox-pip',
  match = {
    class = 'firefox',
    title = 'Picture-in-Picture',
  },
  float = true,
  pin = true,
  border_size = 3,
  opacity = '0.9 0.7',
  no_blur = false,
  move = { '(monitor_w-950)', '(monitor_h-200)' },
  size = utils.size_from_h(16 / 9, 500),
})

hl.window_rule({
  name = 'chromium-pip',
  match = {
    class = '',
    title = 'Picture-in-picture',
  },
  float = true,
  pin = true,
  border_size = 3,
  opacity = '0.9 0.7',
  no_blur = false,
  move = { '(monitor_w-950)', '(monitor_h-200)' },
  size = utils.size_from_h(16 / 9, 500),
})

hl.window_rule({
  name = 'mpv',
  match = {
    class = '(mpv)',
  },
  border_size = 2,
  float = true,
  border_color = 'rgb(00FF00) rgb(00FF00)',
  -- opaque = true,
  opacity = '1.0 0.9',
  pin = true,
})

hl.window_rule({
  name = 'swayimg',
  match = {
    class = '(swayimg)',
  },
  border_size = 2,
  float = true,
  border_color = 'rgb(00FF00) rgb(00FF00)',
  -- opaque = true,
  opacity = '1.0 0.9',
  pin = false,
})
