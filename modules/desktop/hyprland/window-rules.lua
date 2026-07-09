local utils = require('utils')

hl.layer_rule({ match = { namespace = 'waybar' }, blur = true })
hl.layer_rule({
  name = 'noctalia',
  match = {
    namespace = '^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$',
  },
  no_anim = true,
  ignore_alpha = 0.5,
  blur = true,
  blur_popups = true,
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

hl.window_rule({
  name = 'steam',
  match = {
    class = 'steam',
  },
  opacity = '0.9 0.8',
  xray = true,
})

-- hl.window_rule({
--   name = 'hermes',
--   match = {
--     class = 'hermes',
--   },
--   opacity = '0.9 0.8',
--   xray = true,
--   no_blur = true,
-- })

-- hl.config({
--   decoration = {
--     blur = {
--       enabled = true,
--       size = 2,
--       passes = 3,
--       new_optimizations = true,
--       ignore_opacity = true,
--       xray = true,
--       noise = 0.0117,
--       contrast = 0.8916,
--       brightness = 0.8172,
--       vibrancy = 0.1696,
--       vibrancy_darkness = 0.0,
--     },
--   },
-- })

hl.bind('SUPER' .. ' + SHIFT + E', function()
  hl.exec_cmd('hyprctl reload')
end)

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
  name = 'portal',
  match = {
    class = 'xdg-desktop-portal-gtk',
  },
  float = true,
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

hl.window_rule({
  name = 'noctalia settings',
  match = {
    class = 'dev.noctalia.Noctalia.Settings',
  },
  float = true,
  opacity = '0.95 0.8',
})

hl.window_rule({
  name = 'vicinae',
  match = {
    class = 'vicinae',
    title = 'Vicinae Settings',
  },
  border_size = 0,
  float = true,
  opacity = '0.95 0.8',
})

hl.window_rule({
  name = 'generic',
  match = {
    class = 'org.kde.dolphin',
  },
  opacity = '0.9 0.8',
  no_blur = false,
})

hl.window_rule({
  name = 'pip',
  match = {
    class = 'firefox',
    title = 'Picture-in-Picture',
  },
  float = true,
  pin = true,
  border_color = 'rgba(00000000)',
  opacity = '0.9 0.7',
  no_blur = false,
  move = { '(monitor_w-950)', '(monitor_h-200)' },
  size = utils.size_from_h(16 / 9, 500),
})

hl.window_rule({
  name = 'floaterm',
  match = {
    class = 'floaterm',
  },
  float = true,
})

hl.window_rule({
  name = 'media-viewer',
  match = {
    class = '(org.telegram.desktop)|(com.ayugram.desktop)|(io.github.kukuruzka165.materialgram)',
    title = '(Media viewer)',
  },
  float = true,
  fullscreen_state = '0 0',
  size = utils.size_from_h(16 / 9, 900),
  center = true,
})

hl.window_rule({
  name = 'telegraph',
  match = {
    class = '(org.telegram.desktop)|(com.ayugram.desktop)|(io.github.kukuruzka165.materialgram)',
    title = '(Instant View — Telegraph)',
  },
  float = true,
  size = { 900, '(monitor_h*0.9)' },
  center = true,
  move = { '(monitor_w-950)', 100 },
})

hl.window_rule({
  name = 'ark-mainwindow',
  match = { class = 'org.kde.ark' },
  float = true,
})

hl.window_rule({
  name = 'ark-status',
  match = { class = 'org.kde.(ark|dolphin)', title = 'Extracting.* — (Ark|Dolphin)' },
  float = true,
  no_initial_focus = true,
  move = { '(monitor_w-500)', 100 },
})

hl.window_rule({
  name = 'ark-password',
  match = { class = 'org.kde.(ark|dolphin)', title = 'Password — (Ark|Dolphin)' },
  float = true,
  center = true,
})

hl.window_rule({
  name = 'sushi',
  match = { class = 'org.gnome.NautilusPreviewer' },
  float = true,
  center = true,
})

hl.window_rule({
  name = 'digikam-popup',
  match = { class = 'org.kde.digikam', title = '(Edit Album|Slideshow Settings) — digiKam' },
  float = true,
  center = true,
})

hl.window_rule({
  name = 'kde-init',
  match = { class = 'org.kde.(digikam|kdenlive)', title = '(digiKam)|(Kdenlive)' },
  float = true,
  center = true,
})

hl.bind('SUPER + F1', function()
  local game_mode = (hl.get_config('animations.enabled') == false)

  if game_mode then
    hl.exec_cmd('hyprctl reload')
    return
  end

  hl.config({
    general = {
      gaps_in = 0,
      gaps_out = 0, -- Disable gaps
      border_size = 0,
    },

    animations = {
      enabled = false, -- Disable animations
    },

    -- Disable blur, shadow and window rounding
    decoration = {
      shadow = { enabled = false },
      blur = { enabled = false },
      rounding = 0,
    },
  })
end)

hl.bind('SUPER + F2', function()
  local game_mode = (hl.get_config('decoration.blur.enabled') == false)

  if game_mode then
    hl.exec_cmd('hyprctl reload')
    return
  end

  hl.config({
    decoration = {
      rounding = 10,
      active_opacity = 0.9,
      inactive_opacity = 0.6,
      fullscreen_opacity = 0.9,
      shadow = {
        enabled = true,
        range = 30,
        render_power = 3,
        color = '0x66000000',
      },
      blur = {
        enabled = true,
        size = 3,
        passes = 4,
        new_optimizations = true,
        ignore_opacity = true,
        xray = false,
      },
    },
  })
end)

hl.on('window.active', function(w)
  local match = { 'org.kde.polkit-kde-authentication-agent-1' }
  for i = 1, #match do
    if w.class == match[i] then
      hl.timer(function()
        hl.exec_cmd('limes --backend fcitx5-rime --mode ascii true')
      end, { timeout = 150, type = 'oneshot' })
    end
  end
end)

hl.on('window.active', function(w)
  local match = { 'Password — Ark', 'Password — Dolphin' }
  for i = 1, #match do
    if w.title == match[i] then
      hl.timer(function()
        hl.exec_cmd('limes --backend fcitx5-rime --mode ascii true')
      end, { timeout = 150, type = 'oneshot' })
    end
  end
end)
