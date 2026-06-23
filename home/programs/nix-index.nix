_: {
  programs.nix-index.enable = true;
  programs.nix-index.symlinkToCacheHome = true;
  programs.nix-index-database.comma.enable = true;
  misc.shellAliases = {
    "，" = ","; # 全角逗号支持
  };
}
