_: {
  programs.nix-index.enable = true;
  programs.nix-index.symlinkToCacheHome = true;
  programs.nix-index-database.comma.enable = true;
  nixdots.programs.shellAliases = {
    "，" = ","; # 全角逗号支持
  };
}
