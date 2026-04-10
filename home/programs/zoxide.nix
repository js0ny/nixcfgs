{
  lib,
  config,
  ...
}:
let
  zoxideAliases = {
    ".." = "z ..";
    "..." = "z ../..";
    "...." = "z ../../..";
    "....." = "z ../../../..";
    "......" = "z ../../../../..";
    # Compatibility with cjk dots
    "。。" = "z ..";
    "。。。" = "z ../..";
    "。。。。" = "z ../../..";
    "。。。。。" = "z ../../../..";
    "。。。。。。" = "z ../../../../..";
  };
  home = config.nixdots.user.home;
in
{
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
  nixdots.programs.shellAliases = zoxideAliases;
  home.sessionVariables._ZO_EXCLUDE_DIRS = lib.concatStringsSep ":" [
    "/sys/*"
    "/nix/*"
    "/dev/*"
    "/tmp/*"
    "/proc/*"
    "${home}/.cache/*"
  ];
  nixdots.persist.home = {
    directories = [
      ".local/share/zoxide"
    ];
  };
}
