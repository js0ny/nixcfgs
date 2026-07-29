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
    in
    {
      programs.neovim.enable = lib.mkForce false;

      home.packages = [ inputs.nvimdots.packages.${pkgs.stdenv.hostPlatform.system}.default ];

      # home.packages = with pkgs; [lua-language-server];
      misc.shellAliases = nvimAlias;

      xdg.configFile."lsp-snippets".source = snippets;

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
