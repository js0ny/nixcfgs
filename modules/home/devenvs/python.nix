{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixdots.devenvs.python;
in
lib.mkIf cfg.enable {
  home.packages = [
    pkgs.uv
  ]
  ++ lib.optionals cfg.global (
    with pkgs;
    [
      ruff
    ]
  );
  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    ms-python.python
    ms-python.debugpy
    ms-python.vscode-pylance
    charliermarsh.ruff
    njpwerner.autodocstring
  ];
  xdg.configFile."conda/.condarc".text = ''
    auto_activate_base: false
  '';
}
