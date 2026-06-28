{
  flake.homeModules.zed-editor =
    {
      pkgs,
      config,
      ...
    }:
    let
      snippets = (import ../lsp-snippets/lib.nix { inherit pkgs config; }).raw;
    in
    {
      imports = [
        ./settings.nix
        ./keymaps.nix
      ];
      xdg.configFile."zed/snippets".source = snippets;
      programs.zed-editor = {
        enable = true;
        extensions = [
          "material-icon-theme"
        ];
      };
      nixdots.persist.nosnap.home = {
        directories = [
          ".local/share/zed"
        ];
      };
    };
}
