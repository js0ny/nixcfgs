{config, ...}: let
  username = config.nixdots.user.name;
in {
  # system.copySystemConfiguration = true;
  nix.settings = {
    trusted-users = ["${username}" "root"];
    use-xdg-base-directories = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  environment.variables = import ./do-not-track-vars.nix;
}
