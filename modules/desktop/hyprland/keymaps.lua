---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal = "xdg-terminal-exec"
local menu = "vicinae toggle"

---------------------
---- KEYBINDINGS ----
---------------------

local mod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + C", hl.dsp.window.close()):set_enabled(false)
hl.bind(
  mod .. " + M",
  hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
):set_enabled(false)
hl.bind(mod .. " + E", hl.dsp.exec_cmd("xdg-open ~"))
-- hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + V", hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/history"))
hl.bind("ALT + Space", hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(mod .. " + B", hl.dsp.exec_cmd("chromium"))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.kill())

-- Move focus with mainMod + arrow keys
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))

hl.bind(mod .. " + g", hl.dsp.group.toggle())

hl.bind(mod .. " + M", hl.dsp.window.fullscreen())

hl.bind(mod .. " + C", hl.dsp.window.center())

local function toggle_focus_float()
  local win = hl.get_active_window()
  if not win then
    return
  end

  if win.floating then
    hl.dispatch(hl.dsp.window.cycle_next({ tiled = true }))
  else
    hl.dispatch(hl.dsp.window.cycle_next({ floating = true }))
  end
end

hl.bind(mod .. " + F", toggle_focus_float)
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
-- hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic")):set_enabled(false)
-- hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" })):set_enabled(false)

-- hl.unbind(mod .. " + S")
-- hl.unbind(mod .. "+ SHIFT + S")

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness

-- Requires playerctl

hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("grimblast --notify copysave area"))
hl.bind(mod .. " + S", hl.dsp.exec_cmd("grimblast --notify copysave active"))
