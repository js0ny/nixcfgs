{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixdots.devenvs.markdown;
in
lib.mkIf cfg.enable {
  home.packages = [
    pkgs.glow
  ]
  ++ lib.optionals cfg.global (
    with pkgs;
    [
      markdown-oxide
    ]
  );
  xdg.configFile."glow/config.yml".text = /* yaml */ ''
    style: "auto"
    mouse: true
    pager: true
    width: 80
  '';
}
