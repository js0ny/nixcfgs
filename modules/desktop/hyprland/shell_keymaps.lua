local utils = require('utils')
local vars = require('vars')

local mod = vars.mod

local function dms_ipc(cmd)
  return hl.dsp.exec_cmd('dms ipc ' .. cmd)
end

local function noctalia_ipc(cmd)
  return hl.dsp.exec_cmd('noctalia msg ' .. cmd)
end

-- local window_switcher_state = false
-- hl.bind('ALT + TAB', function()
--   if not window_switcher_state then
--     window_switcher_state = true
--     hl.dispatch(noctalia_ipc('window-switcher'))
--   else
--     hl.dispatch(hl.dsp.pass({ window = '^noctalia-window-switcher$' }))
--   end
-- end, { non_consuming = true })
-- hl.on(
--   'layer.closed',
--   ---@param layer HL.LayerSurface
--   function(layer)
--     if layer.namespace == 'noctalia-window-switcher' then
--       window_switcher_state = false
--     end
--   end
-- )

if utils.executable_in_path('noctalia') then
  hl.bind('CTRL + ALT + DELETE', noctalia_ipc('panel-open session'))
  hl.bind(mod .. ' + ALT + i', noctalia_ipc('session lock'))
  hl.bind(mod .. ' + comma', noctalia_ipc('panel-toggle control-center'))
  hl.bind('XF86AudioNext', noctalia_ipc('media next'), { locked = true })
  hl.bind('XF86AudioPause', noctalia_ipc('media toggle'), { locked = true })
  hl.bind('XF86AudioPlay', noctalia_ipc('media toggle'), { locked = true })
  hl.bind('XF86AudioPrev', noctalia_ipc('media prev'), { locked = true })
  hl.bind('XF86AudioRaiseVolume', noctalia_ipc('volume-up'), { locked = true, repeating = true })
  hl.bind('XF86AudioLowerVolume', noctalia_ipc('volume-down'), { locked = true, repeating = true })
  hl.bind('XF86AudioMute', noctalia_ipc('volume-mute'), { locked = true, repeating = true })
  hl.bind('XF86AudioMicMute', noctalia_ipc('mic-mute'), { locked = true, repeating = true })
  hl.bind(
    'XF86MonBrightnessUp',
    noctalia_ipc('brightness-up current 5'),
    { locked = true, repeating = true }
  )
  hl.bind(
    'XF86MonBrightnessDown',
    noctalia_ipc('brightness-down current 5'),
    { locked = true, repeating = true }
  )
elseif utils.executable_in_path('dms') then
  hl.bind('CTRL + ALT + DELETE', dms_ipc('powermenu toggle'))
  hl.bind(mod .. ' + ALT + i', dms_ipc('lock lock'))
  hl.bind(mod .. ' + comma', dms_ipc('control-center toggle'))
  hl.bind('XF86AudioNext', dms_ipc('mpris next'), { locked = true })
  hl.bind('XF86AudioPause', dms_ipc('mpris playPause'), { locked = true })
  hl.bind('XF86AudioPlay', dms_ipc('mpris playPause'), { locked = true })
  hl.bind('XF86AudioPrev', dms_ipc('mpris previous'), { locked = true })
  hl.bind('XF86AudioRaiseVolume', dms_ipc('audio increment 3'), { locked = true, repeating = true })
  hl.bind('XF86AudioLowerVolume', dms_ipc('audio decrement 3'), { locked = true, repeating = true })
  hl.bind('XF86AudioMute', dms_ipc('audio mute'), { locked = true, repeating = true })
  hl.bind('XF86AudioMicMute', dms_ipc('audio micmute'), { locked = true, repeating = true })
  hl.bind(
    'XF86MonBrightnessUp',
    hl.dsp.exec_cmd('brightnessctl -e4 -n2 set 5%+'),
    { locked = true, repeating = true }
  )
  hl.bind(
    'XF86MonBrightnessDown',
    hl.dsp.exec_cmd('brightnessctl -e4 -n2 set 5%-'),
    { locked = true, repeating = true }
  )
else
  hl.bind('XF86AudioNext', hl.dsp.exec_cmd('playerctl next'), { locked = true })
  hl.bind('XF86AudioPause', hl.dsp.exec_cmd('playerctl play-pause'), { locked = true })
  hl.bind('XF86AudioPlay', hl.dsp.exec_cmd('playerctl play-pause'), { locked = true })
  hl.bind('XF86AudioPrev', hl.dsp.exec_cmd('playerctl previous'), { locked = true })
  hl.bind(
    'XF86AudioRaiseVolume',
    hl.dsp.exec_cmd('wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+'),
    { locked = true, repeating = true }
  )
  hl.bind(
    'XF86AudioLowerVolume',
    hl.dsp.exec_cmd('wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-'),
    { locked = true, repeating = true }
  )
  hl.bind(
    'XF86AudioMute',
    hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'),
    { locked = true, repeating = true }
  )
  hl.bind(
    'XF86AudioMicMute',
    hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle'),
    { locked = true, repeating = true }
  )
  hl.bind(
    'XF86MonBrightnessUp',
    hl.dsp.exec_cmd('brightnessctl -e4 -n2 set 5%+'),
    { locked = true, repeating = true }
  )
  hl.bind(
    'XF86MonBrightnessDown',
    hl.dsp.exec_cmd('brightnessctl -e4 -n2 set 5%-'),
    { locked = true, repeating = true }
  )
end
-- TODO:
local qs = '/nix/store/nm6wrf4gprrxlri8nr16kcmixpkk8hrf-quickshell-0.3.0/bin/qs'
hl.bind(
  'ALT + TAB',
  hl.dsp.exec_cmd(qs .. ' ipc -p /home/js0ny/Atelier/prj/qswitcher call switcher next')
)
hl.bind(
  'ALT + SHIFT + TAB',
  hl.dsp.exec_cmd(qs .. ' ipc -p /home/js0ny/Atelier/prj/qswitcher call switcher prev')
)
