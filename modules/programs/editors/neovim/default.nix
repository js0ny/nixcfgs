{
  flake.homeModules.neovim =
    {
      pkgs,
      config,
      inputs,
      lib,
      ...
    }:
    let
      nvimAlias = {
        "v" = "nvim";
        "g" = "nvim +Neogit";
      };
      snippets = (import ../lsp-snippets/lib.nix { inherit pkgs config; }).out;
      appname = "nvim";
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      imports = [
        inputs.nvimdots.homeModules.default
      ];

      nixdots.devenvs.lua.enable = true;

      # home.packages = with pkgs; [lua-language-server];
      misc.shellAliases = nvimAlias;

      xdg.configFile."lsp-snippets".source = snippets;
      xdg.configFile."nvim".source = lib.mkForce (
        mkSymlink "${config.home.homeDirectory}/Atelier/dot/nvimdots"
      );

      stylix.targets.neovim = {
        enable = true;
        plugin = "mini.base16";
        transparentBackground = {
          main = false;
          signColumn = false;
          numberLine = false;
        };
      };

      nixdots.persist.nosnap.home = {
        directories = [
          # nvim(lazy) will download plugins to this dir
          ".local/share/${appname}"
          ".local/state/${appname}"
        ];
      };

      programs.git = {
        settings = {
          merge.tool = "codediff";
          mergetool.codediff = {
            cmd = ''nvim "$MERGED" -c "CodeDiff merge \"$MERGED\""'';
          };
        };
      };
    };
}
