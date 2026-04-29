{
  pkgs,
  lib,
  config,
}:
let
  vicinae = config.nixdefs.consts.vicinae;
  noctalia = config.nixdefs.consts.noctalia;
  nirictl = import ./scripts.nix { inherit pkgs; };
  homeDir = config.home.homeDirectory;
  nirictl-focus = lib.getExe nirictl.focusOrLaunch;
  genCmd = cmd: builtins.concatStringsSep " " (map (x: ''"${x}"'') cmd);
  powerprofiles = lib.getExe pkgs.localPkgs.power-profiles-next;
  term = lib.getExe pkgs.xdg-terminal-exec;
  screenDevice = config.nixdots.laptop.backlight.screen;
  kbdDevice = config.nixdots.laptop.backlight.keyboard;
  kbdStep = "1";
in
/* kdl */ ''
  binds {
      Alt+Print { screenshot-window write-to-disk=true; }
      Alt+Space hotkey-overlay-title="Picker" { spawn ${genCmd vicinae.toggle}; }
      Ctrl+Alt+Delete { quit; }
      Ctrl+Print { screenshot-screen show-pointer=false; }
      Mod+1 { focus-workspace "1-master"; }
      Mod+2 { focus-workspace "2-project"; }
      Mod+3 { focus-workspace "3-alt"; }
      Mod+4 { focus-workspace "4-info"; }
      Mod+5 { focus-workspace "5-bg"; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }
      Mod+A { spawn-sh "${term} --class=terminal-popup -e aichat --session"; }
      Mod+Alt+Down { focus-monitor-down; }
      Mod+Alt+E { spawn "${term}" "yazi"; }
      Mod+Alt+H { focus-monitor-left; }
      Mod+Alt+J { focus-monitor-down; }
      Mod+Alt+K { focus-monitor-up; }
      Mod+Alt+L { focus-monitor-right; }
      Mod+Alt+Left { focus-monitor-left; }
      Mod+Alt+Return { spawn "neovide" "${homeDir}/Atelier"; }
      Mod+Alt+Right { focus-monitor-right; }
      Mod+Alt+S { screenshot-screen show-pointer=false; }
      Mod+Alt+Up { focus-monitor-up; }
      Mod+Alt+i hotkey-overlay-title="Lockscreen" { spawn ${genCmd noctalia.lock}; }
      Mod+Apostrophe { spawn-sh "EDITOR_MINIMAL=1 ${term} -o close_on_child_death=yes --app-id=terminal-popup -e edit-clipboard --minimal"; }
      Mod+B hotkey-overlay-title="Focus or launch web browser" { spawn "${nirictl-focus}" "firefox" "firefox"; }
      Mod+BracketLeft { consume-or-expel-window-left; }
      Mod+BracketRight { consume-or-expel-window-right; }
      Mod+C { center-column; }
      Mod+Ctrl+C { center-visible-columns; }
      Mod+Ctrl+End { move-column-to-last; }
      Mod+Ctrl+F { expand-column-to-available-width; }
      Mod+Ctrl+Home { move-column-to-first; }
      Mod+Ctrl+I { move-column-to-workspace-up; }
      "Mod+Ctrl+Page_Down" { move-column-to-workspace-down; }
      "Mod+Ctrl+Page_Up" { move-column-to-workspace-up; }
      Mod+Ctrl+R { reset-window-height; }
      Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
      Mod+Ctrl+Shift+WheelScrollUp { move-column-left; }
      Mod+Ctrl+U { move-column-to-workspace-down; }
      Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
      Mod+Ctrl+WheelScrollLeft { move-column-left; }
      Mod+Ctrl+WheelScrollRight { move-column-right; }
      Mod+Ctrl+WheelScrollUp cooldown-ms=150 { move-column-to-workspace-up; }
      Mod+Down { focus-window-down; }
      Mod+E hotkey-overlay-title="Launch file explorer" { spawn-sh "xdg-open ~"; }
      Mod+End { focus-column-last; }
      Mod+Equal { set-column-width "+10%"; }
      Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
      Mod+F { toggle-window-floating; }
      Mod+G hotkey-overlay-title="Toggle Grouped Display" { toggle-column-tabbed-display; }
      Mod+Grave { focus-workspace-previous; }
      Mod+H { focus-column-left; }
      Mod+Home { focus-column-first; }
      Mod+I { focus-workspace-up; }
      Mod+J { focus-window-or-workspace-down; }
      Mod+K { focus-window-or-workspace-up; }
      Mod+L { focus-column-right; }
      Mod+Left { focus-column-left; }
      Mod+M { maximize-column; }
      Mod+Minus { set-column-width "-10%"; }
      Mod+O hotkey-overlay-title="Focus or launch Obsidian" { spawn "${nirictl-focus}" "obsidian" "obsidian"; }
      "Mod+Page_Down" { focus-workspace-down; }
      "Mod+Page_Up" { focus-workspace-up; }
      Mod+Q { close-window; }
      Mod+R { switch-preset-column-width; }
      Mod+Return hotkey-overlay-title="Open a Terminal: ${term}" { spawn "${term}"; }
      Mod+Right { focus-column-right; }
      Mod+S { screenshot-window write-to-disk=true; }
      Mod+Shift+1 { move-column-to-workspace "1-master"; }
      Mod+Shift+2 { move-column-to-workspace "2-project"; }
      Mod+Shift+3 { move-column-to-workspace "3-alt"; }
      Mod+Shift+4 { move-column-to-workspace "4-info"; }
      Mod+Shift+5 { move-column-to-workspace "5-bg"; }
      Mod+Shift+6 { move-column-to-workspace 6; }
      Mod+Shift+7 { move-column-to-workspace 7; }
      Mod+Shift+8 { move-column-to-workspace 8; }
      Mod+Shift+9 { move-column-to-workspace 9; }
      Mod+Shift+A hotkey-overlay-title="Focus or launch CherryStudio (AI assistant)" { spawn "${nirictl-focus}" "CherryStudio" "cherry-studio"; }
      Mod+Shift+B hotkey-overlay-title="Launch web browser in private mode" { spawn "firefox" "--private-window"; }
      Mod+Shift+Ctrl+Down { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+H { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+J { move-column-to-monitor-down; }
      Mod+Shift+Ctrl+K { move-column-to-monitor-up; }
      Mod+Shift+Ctrl+L { move-column-to-monitor-right; }
      Mod+Shift+Ctrl+Left { move-column-to-monitor-left; }
      Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
      Mod+Shift+Ctrl+Up { move-column-to-monitor-up; }
      Mod+Shift+Down { move-window-down; }
      Mod+Shift+E { spawn "fsearch"; }
      Mod+Shift+Equal { set-window-height "+10%"; }
      Mod+Shift+F { switch-focus-between-floating-and-tiling; }
      Mod+Shift+H { move-column-left; }
      Mod+Shift+I { move-workspace-up; }
      Mod+Shift+J { move-window-to-workspace-down; }
      Mod+Shift+K { move-window-to-workspace-up; }
      Mod+Shift+L { move-column-right; }
      Mod+Shift+Left { move-column-left; }
      Mod+Shift+M { fullscreen-window; }
      Mod+Shift+Minus { set-window-height "-10%"; }
      Mod+Shift+O { spawn-sh "${term} --app-id=terminal-popup -e obsidian-grep && ${nirictl-focus} obsidian obsidian"; }
      "Mod+Shift+Page_Down" { move-workspace-down; }
      "Mod+Shift+Page_Up" { move-workspace-up; }
      Mod+Shift+R { switch-preset-window-height; }
      Mod+Shift+Return { spawn-sh "kitty --class=terminal-popup"; }
      Mod+Shift+Right { move-column-right; }
      Mod+Shift+S { screenshot show-pointer=false; }
      Mod+Shift+Slash { show-hotkey-overlay; }
      Mod+Shift+U { move-workspace-down; }
      Mod+Shift+Up { move-window-up; }
      Mod+Shift+WheelScrollDown { focus-column-right; }
      Mod+Shift+WheelScrollUp { focus-column-left; }
      Mod+Tab { toggle-overview; }
      Mod+U { focus-workspace-down; }
      Mod+Up { focus-window-up; }
      Mod+V { spawn ${genCmd vicinae.cliphist}; }
      Mod+W { spawn ${genCmd vicinae.windows}; }
      Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
      Mod+WheelScrollLeft { focus-column-left; }
      Mod+WheelScrollRight { focus-column-right; }
      Mod+WheelScrollUp cooldown-ms=150 { focus-workspace-up; }
      Print { screenshot show-pointer=false; }
      XF86AudioMicMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }
      XF86AudioMute allow-when-locked=true { spawn "volume-notify" "mute"; }
      XF86AudioNext { spawn ${genCmd noctalia.media.next}; }
      XF86AudioPlay { spawn ${genCmd noctalia.media.playpause}; }
      XF86AudioPrev { spawn ${genCmd noctalia.media.prev}; }
      XF86AudioRaiseVolume allow-when-locked=true { spawn ${genCmd noctalia.volume.up}; }
      XF86AudioLowerVolume allow-when-locked=true { spawn ${genCmd noctalia.volume.down}; }
      XF86Calculator { spawn ""; }
      XF86KbdBrightnessDown { spawn "brightnessctl" "--device" "${kbdDevice}" "set" "${kbdStep}-"; }
      XF86KbdBrightnessUp { spawn "brightnessctl" "--device" "${kbdDevice}" "set" "${kbdStep}+"; }
      XF86Launch1 { spawn ${genCmd vicinae.toggle}; }
      XF86Launch4 { spawn "${powerprofiles}"; }
      XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "set" "10%-" "--device" "${screenDevice}"; }
      XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "set" "10%+" "--device" "${screenDevice}"; }
      XF86TouchpadToggle { spawn ""; }
  }
''
