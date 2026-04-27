{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixdots.devenvs.verilog;
in
lib.mkIf cfg.enable {
  home.packages =
    with pkgs;
    [
      gtkwave
      picocom
    ]
    ++ lib.optionals cfg.global [
      verilator
      iverilog
      verible
      svls
    ];
  programs.zed-editor.extensions = [ "verilog" ];
}
