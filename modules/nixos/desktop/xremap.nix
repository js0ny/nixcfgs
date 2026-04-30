# This file only contains logic that give previledges to xremap user
# See home-manager configs for detailed options
{
  config,
  lib,
  ...
}:
let
  cfg = config.nixdots.keymaps.xremap;
in
lib.mkIf cfg.enable {

  # treat the virtual keyboard as internal,
  # since most "Disable Trackpad While Typing"
  # won't work if you are using a virtual keyboard.
  # https://github.com/xremap/xremap/discussions/656
  environment.etc."libinput/local-overrides.quirks".text = ''
    [xremap]
    MatchName=xremap
    MatchUdevType=keyboard
    AttrKeyboardIntegration=internal
  '';
}
