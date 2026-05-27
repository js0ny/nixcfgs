{ ... }:
{
  # system.copySystemConfiguration = true;
  environment.variables = import ./do-not-track-vars.nix;
}
