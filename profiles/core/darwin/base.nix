{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.sops-nix.darwinModules.default
    ../shared/hm.nix
  ];
  environment.variables = import ../shared/do-not-track-vars.nix;

  time.timeZone = builtins.head config.js0ny.host.timezones;
  system.primaryUser = config.js0ny.user.name;
  networking.computerName = config.js0ny.host.hostName;
  programs.zsh.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  js0ny.homebrew.casks = [
    "apparency"
    "qlcolorcode"
    "qlmarkdown"
    "qlstephen"
    "quicklook-video"
    "qspace-pro"
    "quicklookase"
  ];
}
