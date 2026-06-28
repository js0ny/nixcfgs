{
  flake.homeModules.social-tencent = { ... }: {
    imports = [
      ./qq.nix
      ./wechat.nix
    ];
  };
}
