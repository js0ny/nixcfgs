{ pkgs, lib, ... }:
let
  ctrlBI = [
    # Terminal
    "^com\.apple\.Terminal$"
    "^org\.alacritty$"
    "^com\.googlecode\.iterm2$"
    "^com\.github\.wez\.wezterm$"
    "^net\.kovidgoyal\.kitty$"
    "^com\.mitchellh\.ghostty$"

    # Editor
    "^com\.neovide\.neovide$"
    "^org\.gnu\.Emacs$"
    "^com\.microsoft\.VSCode$"
    "^com\.jetbrains\.rider$"
    "^com\.jetbrains\.pycharm$"
    "^com\.jetbrains\.intellij$"
    "^com\.jetbrains\.goland$"
    "^com\.jetbrains\.clion$"
    "^com\.jetbrains\.rustrover$"
    "^dev\.zed\.Zed$"

    # VM & Remote Desktops
    "^com\.utmapp\.UTM$"
    "^com\.moonlight-stream\.Moonlight$"

    # Misc
    "^com\.raycast\.macos$"
  ];
in
lib.mkIf pkgs.stdenv.isDarwin {
  xdg.configFile."karabiner/assets/complex_modifications/0.json".text = builtins.toJSON {
    description = "Caps Lock: Ctrl in when coding, Cmd elsewhere, Esc when alone";
    manipulators = [
      {
        conditions = [
          {
            bundle_identifiers = ctrlBI;
            type = "frontmost_application_if";
          }
        ];
        from = {
          key_code = "caps_lock";
          modifiers = {
            optional = [
              "any"
            ];
          };
        };
        to = [
          {
            key_code = "left_control";
          }
        ];
        to_if_alone = [
          {
            key_code = "escape";
          }
        ];
        type = "basic";
      }
      {
        conditions = [
          {
            bundle_identifiers = ctrlBI;
            type = "frontmost_application_unless";
          }
        ];
        from = {
          key_code = "caps_lock";
          modifiers = {
            optional = [
              "any"
            ];
          };
        };
        to = [
          {
            key_code = "left_command";
          }
        ];
        to_if_alone = [
          {
            key_code = "escape";
          }
        ];
        type = "basic";
      }
    ];
  };
  nixdots.darwin.homebrew.casks = [ "karabiner-elements" ];
}
