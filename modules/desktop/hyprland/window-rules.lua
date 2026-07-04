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
  no_blur = true,
})

hl.config({
  decoration = {
    blur = {
      enabled = true,
      size = 12,
      passes = 6,
      new_optimizations = true,
      ignore_opacity = true,
      xray = true,
      noise = 0.0117,
      contrast = 0.8916,
      brightness = 0.8172,
      vibrancy = 0.1696,
      vibrancy_darkness = 0.0,
    },
  },
})

-- 关键：waybar 也 blur
hl.layer_rule({ match = { namespace = 'waybar' }, blur = true })

hl.window_rule({
  name = 'polkit',
  match = {
    class = 'org.kde.polkit-kde-authentication-agent-1',
  },
  pin = true,
  stay_focused = true,
})

hl.window_rule({
  name = 'IM Wsp 4 Telegram',
  match = {
    class = '(com.ayugram.desktop)|(org.telegram.desktop)|(io.github.kukuruzka165.materialgram)',
  },
  workspace = 4,
  opacity = '0.9 0.8',
})

hl.window_rule({
  name = 'IM Wsp4 Misc',
  match = {
    class = 'QQ',
  },
  workspace = 4,
  opacity = '0.95 0.85',
})
