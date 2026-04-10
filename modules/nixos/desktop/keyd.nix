{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.desktop.keyd.enable;
  key = config.nixdots.laptop.keyboard;
in
lib.mkIf cfg {
  services.keyd = {
    enable = false;
    keyboards = {
      externalKeyboard = {
        ids = [ "${key.idVendor}:${key.idProduct}" ];
        settings = {
          main = {
            capslock = "overload(control, esc)";
          };
        };
      };
    };
  };
  # See https://github.com/rvaiya/keyd?tab=readme-ov-file#faqs
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd*keyboard
    AttrKeyboardIntegration=internal
  '';
}
