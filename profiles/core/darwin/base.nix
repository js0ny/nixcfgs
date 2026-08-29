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

  time.timeZone = builtins.head config.nixdots.core.timezones;
  system.primaryUser = config.js0ny.user.name;
  networking.computerName = config.nixdots.core.hostname;
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
