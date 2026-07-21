local utils = require('utils')
local vars = require('vars')

local uwsm_exec = utils.uwsm_exec
local term_exec_float = utils.term_exec_float

---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal = 'xdg-terminal-exec'
local menu = 'vicinae toggle'

---------------------
---- KEYBINDINGS ----
---------------------

local mod = vars.mod -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mod .. ' + Return', hl.dsp.exec_cmd(terminal))
hl.bind(
  mod .. ' + M',
  hl.dsp.exec_cmd(
    "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"
  )
):set_enabled(false)
-- hl.bind(mod .. ' + E', uwsm_exec('dolphin'))
hl.bind(mod .. ' + E', uwsm_exec('dolphin'))
-- hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. ' + V', hl.dsp.exec_cmd('vicinae deeplink vicinae://launch/clipboard/history'))
hl.bind(mod .. ' + SHIFT + V', term_exec_float('edit-clipboard'))
hl.bind('ALT + Space', hl.dsp.exec_cmd(menu))
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(mod .. ' + B', uwsm_exec('firefox'))
hl.bind(mod .. ' + SHIFT + B', uwsm_exec('firefox --private-window'))
hl.bind(mod .. ' + Q', hl.dsp.window.close())
hl.bind(mod .. ' + SHIFT + Q', hl.dsp.window.kill())

-- Move focus with mainMod + arrow keys
hl.bind(mod .. ' + left', hl.dsp.focus({ direction = 'left' }))
hl.bind(mod .. ' + right', hl.dsp.focus({ direction = 'right' }))
hl.bind(mod .. ' + up', hl.dsp.focus({ direction = 'up' }))
hl.bind(mod .. ' + down', hl.dsp.focus({ direction = 'down' }))
hl.bind(mod .. ' + H', hl.dsp.focus({ direction = 'left' }))
hl.bind(mod .. ' + L', hl.dsp.focus({ direction = 'right' }))
hl.bind(mod .. ' + K', hl.dsp.focus({ direction = 'up' }))
hl.bind(mod .. ' + J', hl.dsp.focus({ direction = 'down' }))
hl.bind(mod .. ' + SHIFT + H', hl.dsp.window.swap({ direction = 'left' }))
hl.bind(mod .. ' + SHIFT + L', hl.dsp.window.swap({ direction = 'right' }))
hl.bind(mod .. ' + SHIFT + K', hl.dsp.window.swap({ direction = 'up' }))
hl.bind(mod .. ' + SHIFT + J', hl.dsp.window.swap({ direction = 'down' }))

hl.bind(mod .. ' + G', hl.dsp.group.toggle())

hl.bind(mod .. ' + R', hl.dsp.layout('colresize +conf'))
hl.bind(mod .. ' + SHIFT + R', hl.dsp.layout('colresize -conf'))

hl.bind(mod .. ' + EQUAL', hl.dsp.layout('colresize +0.1'))
hl.bind(mod .. ' + MINUS', hl.dsp.layout('colresize -0.1'))
hl.bind(mod .. ' + BRACKETLEFT', hl.dsp.window.move({ direction = 'left', group_aware = true }))
hl.bind(mod .. ' + BRACKETRIGHT', hl.dsp.window.move({ direction = 'right', group_aware = true }))
hl.bind(mod .. ' + M', hl.dsp.window.fullscreen({ mode = 'maximized', action = 'toggle' }))
hl.bind(mod .. ' + SHIFT + M', hl.dsp.window.fullscreen({ mode = 'fullscreen', action = 'toggle' }))

hl.bind(mod .. ' + C', hl.dsp.layout('fit expand'))

hl.bind(mod .. ' + F', utils.toggle_focus_float)
hl.bind(mod .. ' + SHIFT + F', hl.dsp.window.float({ action = 'toggle' }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mod .. ' + ' .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. ' + SHIFT + ' .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
-- hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic")):set_enabled(false)
-- hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" })):set_enabled(false)

-- hl.unbind(mod .. " + S")
-- hl.unbind(mod .. "+ SHIFT + S")

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mod .. ' + mouse_down', hl.dsp.focus({ workspace = 'e-1' }))
hl.bind(mod .. ' + mouse_up', hl.dsp.focus({ workspace = 'e+1' }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mod .. ' + mouse:272', hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. ' + mouse:273', hl.dsp.window.resize(), { mouse = true })

-- Screenshot
hl.bind(mod .. ' + SHIFT + S', hl.dsp.exec_cmd('grimblast --notify copysave area'))
hl.bind(mod .. ' + S', hl.dsp.exec_cmd('grimblast --notify copysave active'))
hl.bind('Print', hl.dsp.exec_cmd('grimblast --notify copysave output'))

hl.bind(
  mod .. ' + W',
  hl.dsp.exec_cmd('vicinae deeplink vicinae://launch/@nino-mau/store.vicinae.hypr/windows')
)

hl.bind(mod .. ' + GRAVE', function()
  local last_workspace = hl.get_last_workspace()
  if last_workspace then
    hl.dispatch(hl.dsp.focus({ workspace = last_workspace.id }))
  end
end)

-- hl.bind('ALT + TAB', function()
--   local win = hl.get_active_window()
--   if not win then
--     return
--   end
--
--   hl.notification.create({
--     text = 'Youre using: ' .. tostring(hl.get_cursor_pos().x) .. ' y ' .. tostring(
--       hl.get_cursor_pos().y
--     ),
--     timeout = 10000,
--   })
-- end)
