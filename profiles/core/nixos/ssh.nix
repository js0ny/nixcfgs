{ config, ... }:
let
  keys = [
    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_ed25519_key.pub"
    "/etc/ssh/ssh_host_rsa_key"
    "/etc/ssh/ssh_host_rsa_key.pub"
  ];
in
{
  programs.ssh.knownHosts = config.nixdefs.misc.ssh.knownHosts;
  js0ny.persist.stores.state.files = map (f: {
    file = f;
    how = "symlink";
    inInitrd = true;
    configureParent = true;
  }) keys;
}
