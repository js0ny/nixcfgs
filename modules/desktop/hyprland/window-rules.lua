hl.window_rule({
  name = 'mpv',
  match = {
    class = 'mpv',
  },
  border_size = 2,
  float = true,
  border_color = 'rgb(00FF00) rgb(00FF00)',
  -- opaque = true,
  opacity = '1.0 0.9',
  pin = true,
})

hl.window_rule({
  name = 'steam',
  match = {
    class = 'steam',
  },
  opacity = '0.9 0.8',
  xray = true,
})

hl.window_rule({
  name = 'hermes',
  match = {
    class = 'hermes',
  },
  opacity = '0.9 0.8',
  xray = true,
})

hl.config({
  decoration = {
    blur = {
      enabled = true,
      size = 2,
      passes = 4,
      new_optimizations = true,
      ignore_opacity = true,
      xray = true,
      vibrancy = 0.1696,
    },
  },
})
