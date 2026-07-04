{
  pkgs,
  hyprlandPackage ? pkgs.hyprland,
  ...
}:
{
  # https://github.com/basecamp/omarchy/blob/dev/bin/omarchy-launch-or-focus
  # License: MIT
  launch-or-focus = pkgs.writeShellApplication {
    name = "hyprland-launch-or-focus";
    runtimeInputs = [
      pkgs.jq
      hyprlandPackage
      pkgs.uwsm
    ];
    text = ''
      if (($# == 0)); then
        echo "Launch an app or focus an existing window matching a pattern"
        echo "Usage: hyprland-launch-or-focus [window-pattern] [launch-command]"
        exit 1
      fi

      if [[ $XDG_CURRENT_DESKTOP != "Hyprland" ]]; then
        echo "The script is for Hyprland only"
        exit 1
      fi

      WINDOW_PATTERN="$1"
      LAUNCH_COMMAND="''${"2:-" "uwsm-app -- $WINDOW_PATTERN"}"
      WINDOW_ADDRESS=$(hyprctl clients -j | jq -r --arg p "$WINDOW_PATTERN" '.[]|select((.class|test("\\b" + $p + "\\b";"i")) or (.title|test("\\b" + $p + "\\b";"i")))|.address' | head -n1)

      if [[ -n $WINDOW_ADDRESS ]]; then
        hyprctl dispatch "hl.dsp.focus({ window = \"address:$WINDOW_ADDRESS\" })" >/dev/null 2>&1 || hyprctl dispatch focuswindow "address:$WINDOW_ADDRESS"
      else
        eval exec setsid $LAUNCH_COMMAND
      fi
    '';
  };
}
