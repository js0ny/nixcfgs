{
  flake.nixosModules.nix-index-database = { inputs, ... }: {
    imports = [ inputs.nix-index-database.nixosModules.default ];
    programs.nix-index.enable = true;
  };
  flake.darwinModules.nix-index-database = { inputs, ... }: {
    imports = [ inputs.nix-index-database.darwinModules.nix-index ];
    programs.nix-index.enable = true;
  };
  flake.homeModules.nix-index-database = { inputs, ... }: {
    imports = [ inputs.nix-index-database.homeModules.nix-index ];
    programs.nix-index.enable = true;
    programs.nix-index.symlinkToCacheHome = true;
    programs.nix-index-database.comma.enable = true;
    misc.shellAliases = {
      "，" = ","; # 全角逗号支持
    };
  };
}
