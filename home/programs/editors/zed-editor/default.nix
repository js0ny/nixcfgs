{
  pkgs,
  config,
  ...
}:
let
  snippets = (import ../lsp-snippets { inherit pkgs config; }).raw;
in
{
  imports = [
    ../default.nix
    ./settings.nix
    ./keymaps.nix
  ];
  xdg.configFile."zed/snippets".source = snippets;
  programs.zed-editor = {
    enable = true;
    package = if pkgs.stdenv.isLinux then pkgs.zed-editor-fhs else pkgs.zed-editor;
    extensions = [
      "material-icon-theme"
    ];
  };
  nixdots.persist.home = {
    directories = [
      ".config/zed"
      ".local/share/zed"
    ];
  };
}
