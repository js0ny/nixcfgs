{
  config,
  inputs,
  ...
}:
let
  inherit (inputs.nixpkgs) lib;

  hosts = lib.filterAttrs (_: host: host ? deploy) (import ../../definitions/hosts.nix).nixos;

  mkNode = name: host: {
    hostname = host.tailscaleIp;
    profiles.system = {
      user = "root";
      sshUser = "js0ny";
      interactiveSudo = host.deploy.interactiveSudo or false;
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos config.flake.nixosConfigurations.${name};
    };
  };
in
{
  flake.deploy = {
    sshOpts = [
      "-p"
      "2223"
    ];
    nodes = lib.mapAttrs mkNode hosts;
  };
}
