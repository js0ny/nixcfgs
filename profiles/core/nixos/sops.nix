{
  pkgs,
  lib,
  config,
  ...
}:
let
  keyFile = config.sops.age.keyFile;
in
{
  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  js0ny.persist.stores.state.files =
    lib.optionals (keyFile != null && !lib.hasPrefix config.js0ny.user.home keyFile)
      [
        {
          file = keyFile;
          how = "symlink";
          mode = "0400";
        }
      ];
}
