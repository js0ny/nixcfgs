{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.keymaps.keyd;
  key = config.nixdots.laptop.keyboard;
in
lib.mkIf cfg.enable {
  services.keyd = {
    enable = true;
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
  environment.etc."libinput/local-overrides.quirks".text = /* ini */ ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd*keyboard
    AttrKeyboardIntegration=internal
  '';
}
