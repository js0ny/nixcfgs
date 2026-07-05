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

    ../../modules/programs/gaming/emulators/retroarch.nix
    ./linux-base.nix
    inputs.self.homeModules.easyeffects
    inputs.self.homeModules.nix-index-database
    inputs.self.homeModules.pim
    inputs.self.homeModules.starship
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
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  nixdots.persist.home.directories = [
    ".local/share/direnv"
  ];
}
