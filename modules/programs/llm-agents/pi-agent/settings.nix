{
  # https://pi.dev/docs/latest/keybindings
  xdg.configFile."pi/agent/keybindings.json".text = builtins.toJSON {
    "tui.editor.cursorUp" = [
      "up"
      "ctrl+p"
    ];
    "tui.editor.cursorDown" = [
      "down"
      "ctrl+n"
    ];
    "app.editor.external" = [
      "ctrl+g"
      "alt+e"
    ];
    "app.model.select" = [
      "ctrl+shift+m"
    ];
    "app.model.cycleForward" = [
      "ctrl+m"
    ];
    "app.model.cycleBackward" = [ ];
  };
}
