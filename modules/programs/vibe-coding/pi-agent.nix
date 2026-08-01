{ pkgs, ... }: {
  home.packages = with pkgs; [
    llm-agents.pi
  ];
  home.file.".pi/agent/keybindings.json".text = builtins.toJSON {
    "tui.editor.cursorUp" = [
      "up"
      "ctrl+p"
    ];
    "tui.editor.cursorDown" = [
      "down"
      "ctrl+n"
    ];
    "tui.editor.cursorLeft" = [
      "left"
      "ctrl+b"
    ];
    "tui.editor.cursorRight" = [
      "right"
      "ctrl+f"
    ];
    "tui.editor.cursorWordLeft" = [
      "alt+left"
      "alt+b"
    ];
    "tui.editor.cursorWordRight" = [
      "alt+right"
      "alt+f"
    ];
    "tui.editor.deleteCharForward" = [
      "delete"
      "ctrl+d"
    ];
    "tui.editor.deleteCharBackward" = [
      "backspace"
      "ctrl+h"
    ];
    "tui.input.newLine" = [
      "shift+enter"
      "ctrl+j"
    ];
    "app.editor.external" = [ "alt+e" ];
    "app.model.cycleForward" = [ ];
  };
  home.sessionVariables = {
    PI_CODING_AGENT_SESSION_DIR = "/persist/home/js0ny/.local/share/pi/agent/session";
    PI_CODING_AGENT_DIR = "/persist/home/js0ny/.config/pi/agent";
  };
}
