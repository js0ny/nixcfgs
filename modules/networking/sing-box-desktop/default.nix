{
  flake.nixosModules.sing-box-desktop =
    { inputs, ... }:
    {
      imports = [ inputs.sfd-nix.nixosModules.default ];

      programs.sing-box-for-desktop = {
        enable = true;
        settings = {
          startAtLogin = true;
          tray = {
            enable = true;
            keepInBackground = true;
          };
          core = {
            insecureMode = false;
            disableDeprecatedWarnings = true;
          };
        };
      };

      # [Human Intervention] Import the remote subscription and enable its TUN profile in the desktop client.
    };
}
