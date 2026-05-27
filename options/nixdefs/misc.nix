{ lib, ... }:
{
  options.nixdefs.misc = {
    ssh = {
      knownHosts = lib.mkOption {
        type = lib.types.attrs;
      };
      sshKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "List of SSH public keys for the user.";
      };
    };
  };
}
