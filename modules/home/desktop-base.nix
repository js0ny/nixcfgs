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

    ../../modules/packages/cli.nix
    ../../modules/packages/devtools.nix
    ../../modules/packages/gui.nix
    ../../modules/programs/gaming/emulators/retroarch.nix
    ./linux-base.nix
    inputs.self.homeModules.easyeffects
    inputs.self.homeModules.mpv
    inputs.self.homeModules.niri
    inputs.self.homeModules.nix-index-database
    inputs.self.homeModules.pim
    inputs.self.homeModules.starship
    inputs.self.homeModules.thunderbird
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
