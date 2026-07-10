{
  flake.darwinModules.brew = import ./brew.nix;
  flake.darwinModules.determinate = import ./determinate.nix;
  flake.darwinModules.finder = import ./finder.nix;
  flake.darwinModules.stylix = import ./stylix.nix;

  flake.darwinModules.core =
    { inputs, config, ... }:
    {
      imports = [
        inputs.self.darwinModules.stylix
        inputs.self.darwinModules.brew
        inputs.self.darwinModules.sshd
        inputs.self.darwinModules.tailscale
      ];
      time.timeZone = builtins.head config.nixdots.core.timezones;
      programs.ssh.knownHosts = config.nixdefs.misc.ssh.knownHosts;
      system.primaryUser = config.nixdots.user.name;
      networking.computerName = config.nixdots.core.hostname;
      programs.zsh.enable = true;
      security.pam.services.sudo_local = {
        touchIdAuth = true;
      };
    };
}
