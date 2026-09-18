{
  pkgs,
  lib,
  config,
}:
let
  vicinae = config.nixdefs.consts.vicinae;
  shell = config.nixdefs.consts.noctalia;
  nirictl = import ./scripts.nix { inherit pkgs lib config; };
  # homeDir = config.home.homeDirectory;
  nirictl-focus = lib.getExe nirictl.focusOrLaunch;
  genCmd = cmd: builtins.concatStringsSep " " (map (x: ''"${x}"'') cmd);
  term = lib.getExe pkgs.xdg-terminal-exec;
  screenDevice = config.js0ny.hardware.laptop.backlight.screen;
  kbdDevice = config.js0ny.hardware.laptop.backlight.keyboard;
  kbdStep = "1";
  killWindow = nirictl.killWindow;
in
/* kdl */ ''
  binds {
      // Applications
      Mod+Return hotkey-overlay-title="Open a Terminal: ${term}" { spawn "${term}"; }
      Mod+Shift+Return { spawn-sh "kitty --class=terminal-float"; }
      Mod+B hotkey-overlay-title="Focus or launch web browser" { spawn "${nirictl-focus}" "firefox" "firefox"; }
      Mod+Shift+B hotkey-overlay-title="Launch web browser in private mode" { spawn "firefox" "--private-window"; }
      Mod+O hotkey-overlay-title="Focus or launch Obsidian" { spawn "${nirictl-focus}" "obsidian" "obsidian"; }
      Mod+Shift+A hotkey-overlay-title="Focus or launch CherryStudio (AI assistant)" { spawn "${nirictl-focus}" "CherryStudio" "cherry-studio"; }
      Mod+E hotkey-overlay-title="Launch file explorer" { spawn-sh "xdg-open ~"; }
      Mod+A { spawn-sh "${term} --class=terminal-float -e aichat --session"; }
      Mod+Alt+E { spawn "${term}" "yazi"; }
      Mod+Apostrophe { spawn-sh "EDITOR_MINIMAL=1 ${term} -o close_on_child_death=yes --app-id=terminal-float -e edit-clipboard --minimal"; }

      // Picker
      Alt+Space hotkey-overlay-title="Picker" { spawn ${genCmd vicinae.toggle}; }
      XF86Launch1 { spawn ${genCmd vicinae.toggle}; }
      Mod+V { spawn ${genCmd vicinae.cliphist}; }
      Mod+W { spawn ${genCmd vicinae.windows}; }
      Mod+Period { spawn ${genCmd vicinae.emoji}; }

      // Screenshots
      Mod+Shift+S { screenshot; }
      Print { screenshot; }
      Mod+S { screenshot-window; }
      Alt+Print { screenshot-window; }
      Ctrl+Print { screenshot-screen; }
      Mod+Alt+S { screenshot-screen; }

      // Session
      Ctrl+Alt+Delete { spawn ${genCmd shell.session}; }
      Mod+Alt+i hotkey-overlay-title="Lockscreen" { spawn ${genCmd shell.lock}; }

      // Workspaces
      Mod+1 { focus-workspace "1-browser"; }
      Mod+2 { focus-workspace "2-project"; }
      Mod+3 { focus-workspace "3-alt"; }
      Mod+4 { focus-workspace "4-info"; }
      Mod+5 { focus-workspace "5-bg"; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }
      Mod+0 { focus-workspace 10; }
      Mod+Grave { focus-workspace-previous; }
      "Mod+Page_Up" { focus-workspace-up; }
      "Mod+Page_Down" { focus-workspace-down; }
      Mod+U { focus-workspace-down; }
      Mod+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }
      Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
      Mod+Shift+1 { move-column-to-workspace "1-browser"; }
      Mod+Shift+2 { move-column-to-workspace "2-project"; }
      Mod+Shift+3 { move-column-to-workspace "3-alt"; }
      Mod+Shift+4 { move-column-to-workspace "4-info"; }
      Mod+Shift+5 { move-column-to-workspace "5-bg"; }
      Mod+Shift+6 { move-column-to-workspace 6; }
      Mod+Shift+7 { move-column-to-workspace 7; }
      Mod+Shift+8 { move-column-to-workspace 8; }
      Mod+Shift+9 { move-column-to-workspace 9; }
      "Mod+Shift+Page_Up" { move-workspace-up; }
      "Mod+Shift+Page_Down" { move-workspace-down; }
      Mod+Shift+I { move-workspace-up; }
      Mod+Shift+U { move-workspace-down; }

      // Focus
      Mod+H { focus-column-left; }
      Mod+J { focus-window-or-workspace-down; }
      Mod+K { focus-window-or-workspace-up; }
      Mod+L { focus-column-right; }
      Mod+Left { focus-column-left; }
      Mod+Right { focus-column-right; }
      Mod+Home { focus-column-first; }
      Mod+End { focus-column-last; }
      Mod+Up { focus-window-up; }
      Mod+Down { focus-window-down; }
      Mod+WheelScrollLeft { focus-column-left; }
      Mod+WheelScrollRight { focus-column-right; }
      Mod+Shift+WheelScrollUp { focus-column-left; }
      Mod+Shift+WheelScrollDown { focus-column-right; }

      // Layout & Sizing
      Mod+C { center-column; }
      Mod+Ctrl+C { center-visible-columns; }
      Mod+M { maximize-column; }
      Mod+Shift+M { fullscreen-window; }
      Mod+G hotkey-overlay-title="Toggle Grouped Display" { toggle-column-tabbed-display; }
      Mod+R { switch-preset-column-width; }
      Mod+Shift+R { switch-preset-window-height; }
      Mod+Equal { set-column-width "+10%"; }
      Mod+Minus { set-column-width "-10%"; }
      Mod+Shift+Equal { set-window-height "+10%"; }
      Mod+Shift+Minus { set-window-height "-10%"; }
      Mod+Ctrl+R { reset-window-height; }
      Mod+Ctrl+F { expand-column-to-available-width; }
      Mod+Shift+F { toggle-window-floating; }
      Mod+F { switch-focus-between-floating-and-tiling; }
      Mod+Q { close-window; }
      Mod+Shift+Q { spawn "${lib.getExe killWindow}"; }

      // Moving Windows
      Mod+Shift+H { move-column-left; }
      Mod+Shift+Left { move-column-left; }
      Mod+Shift+L { move-column-right; }
      Mod+Shift+Right { move-column-right; }
      Mod+Shift+Up { move-window-up; }
      Mod+Shift+Down { move-window-down; }
      Mod+Shift+K { move-window-to-workspace-up; }
      Mod+Shift+J { move-window-to-workspace-down; }
      Mod+BracketLeft { consume-or-expel-window-left; }
      Mod+BracketRight { consume-or-expel-window-right; }
      Mod+Ctrl+Home { move-column-to-first; }
      Mod+Ctrl+End { move-column-to-last; }
      "Mod+Ctrl+Page_Up" { move-column-to-workspace-up; }
      Mod+Ctrl+I { move-column-to-workspace-up; }
      Mod+Ctrl+WheelScrollUp cooldown-ms=150 { move-column-to-workspace-up; }
      "Mod+Ctrl+Page_Down" { move-column-to-workspace-down; }
      Mod+Ctrl+U { move-column-to-workspace-down; }
      Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
      Mod+Ctrl+WheelScrollLeft { move-column-left; }
      Mod+Ctrl+WheelScrollRight { move-column-right; }
      Mod+Ctrl+Shift+WheelScrollUp { move-column-left; }
      Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }

      // Monitors
      Mod+Alt+H { focus-monitor-left; }
      Mod+Alt+Left { focus-monitor-left; }
      Mod+Alt+L { focus-monitor-right; }
      Mod+Alt+Right { focus-monitor-right; }
      Mod+Alt+K { focus-monitor-up; }
      Mod+Alt+Up { focus-monitor-up; }
      Mod+Alt+J { focus-monitor-down; }
      Mod+Alt+Down { focus-monitor-down; }
      Mod+Shift+Ctrl+H { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+Left { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+L { move-column-to-monitor-right; }
      Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
      Mod+Shift+Ctrl+K { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+Up { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+J { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+Down { move-column-to-monitor-down; }

      // Media & Brightness
      XF86AudioRaiseVolume allow-when-locked=true { spawn ${genCmd shell.volume.up}; }
      XF86AudioLowerVolume allow-when-locked=true { spawn ${genCmd shell.volume.down}; }
      XF86AudioMute allow-when-locked=true { spawn ${genCmd shell.volume.mute}; }
      XF86AudioMicMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }
      XF86AudioPrev { spawn ${genCmd shell.media.prev}; }
      XF86AudioPlay { spawn ${genCmd shell.media.playpause}; }
      XF86AudioNext { spawn ${genCmd shell.media.next}; }
      XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "set" "10%+" "--device" "${screenDevice}"; }
      XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "set" "10%-" "--device" "${screenDevice}"; }
      XF86KbdBrightnessUp { spawn "brightnessctl" "--device" "${kbdDevice}" "set" "${kbdStep}+"; }
      XF86KbdBrightnessDown { spawn "brightnessctl" "--device" "${kbdDevice}" "set" "${kbdStep}-"; }

      // Miscellaneous
      Mod+Tab { toggle-overview; }
      Mod+Shift+Slash { show-hotkey-overlay; }
      Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
      XF86Launch4 { spawn ${genCmd shell.powerProfile}; }
      XF86Calculator { spawn ""; }
      XF86TouchpadToggle { spawn ""; }
  }
''
