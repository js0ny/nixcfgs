{
  lib,
  config,
  myLib,
  ...
}:
{
  imports = [
    # keep-sorted start

    ./linux-base.nix
    ../../modules/desktop/home/niri/module.nix
    ../../modules/packages/devtools.nix
    ../../modules/packages/flatpak.nix
    ../../modules/packages/gui.nix
    ../../modules/programs/gaming/emulators/retroarch.nix
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
