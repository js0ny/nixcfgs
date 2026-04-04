# overlays/localPkgs.nix
final: prev: {
  # 将所有自定义包挂载到自定义命名空间下
  localPkgs = import ../pkgs {
    pkgs = final;
    inherit (final) lib;
  };
}
