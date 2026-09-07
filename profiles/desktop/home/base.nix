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
    ../../../modules/programs/gaming/emulators/retroarch.nix
    inputs.self.homeModules.linux
    inputs.self.homeModules.nix-index-database
    inputs.self.homeModules.pim
    inputs.self.homeModules.starship
    # keep-sorted end
  ];

  nixdefs = {
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
  js0ny.persist.stores.state.directories = [ ".local/share/direnv" ];
  services.flatpak.packages = config.js0ny.flatpak.packages;
}
