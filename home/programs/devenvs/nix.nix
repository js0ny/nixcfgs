{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixfmt
    nil
    nixd
  ];
  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
  ];

  programs.zed-editor.extensions = [ "nix" ];
}
