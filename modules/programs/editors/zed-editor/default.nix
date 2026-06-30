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
          # keep-sorted start
          "git-firefly"
          "json5"
          "jsonl"
          "just"
          "make"
          "material-icon-theme"
          # keep-sorted end
        ];
      };
      nixdots.persist.nosnap.home = {
        directories = [
          ".local/share/zed"
        ];
      };
    };
}
