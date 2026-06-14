{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixdots.devenvs.dotnet;
in
lib.mkIf cfg.enable {
  home.packages =
    with pkgs;
    [
      jetbrains.rider
    ]
    ++ lib.optionals cfg.global [
      dotnet-sdk_10
    ];
  programs.zed-editor = {
    extensions = [
      "csharp"
      "fsharp"
    ];
    userSettings = {
    };
  };
  programs.vscode.extensions = with pkgs.vscode-extensions; [
    ms-dotnettools.csharp
    ms-dotnettools.csdevkit
  ];
}
