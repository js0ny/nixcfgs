{
  lib,
  config,
  myLib,
  inputs,
  ...
}:
{
  imports = [
    # keep-sorted start

    ../../modules/desktop/home/niri/module.nix
    ../../modules/packages/devtools.nix
    ../../modules/packages/gui.nix
    ../../modules/programs/gaming/emulators/retroarch.nix
    ./linux-base.nix
    # keep-sorted end
  ];

  nixdots.persist.nosnap.home = {
    directories = [ ".local/state/wireplumber" ];
  };

  nixdefs = {
    acp.enable = true;
    llm.enable = true;
    mcp.enable = true;
    hardware.enable = true;
  };

  home.file.".hidden".text = lib.concatStringsSep "\n" [
    "PDX"
  ];
}
