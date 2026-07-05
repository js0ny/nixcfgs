{
  flake.homeModules.social-tencent = { ... }: {
    imports = [
      ./qq.nix
      ./wechat.nix
    ];
  };
  flake.nixosModules.social-tencent = { config, ... }: {
    # Disable QQ auto-update via tmpfs that does not have enough space for the update files.
    fileSystems = {
      "${config.nixdots.user.home}/.config/QQ/versions" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [
          "size=1M"
          "mode=0755"
          "uid=1000"
          "gid=100"
          "x-systemd.requires-mounts-for=${config.nixdots.user.home}/.config/QQ"
        ];
      };
    };
  };
  flake.nixosModules.desktop = { inputs, ... }: {
    imports = [ inputs.self.nixosModules.social-tencent ];
  };
}
