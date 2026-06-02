{
  pkgs,
  lib,
  config,
  inputs,
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
  vicinae-extensions = inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
  misc.shellAliases = zoxideAliases;
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
  systemd.user.tmpfiles.rules = [
    "R ${config.xdg.dataHome}/zoxide/tmp_* - - - 1d"
  ];
  programs.vicinae = {
    extensions = with vicinae-extensions; [ zoxide-recent-directories ];
    settings = {
      providers = {
        "@c4n4m1/vicinae-extension-zoxide-recent-directories-0" = {
          preferences = {
            application = lib.getExe' pkgs.xdg-utils "xdg-open";
            defaultFilter = "all";
            alternativeApplication = lib.getExe pkgs.xdg-terminal-exec;
          };
          entrypoints.recent-directories.alias = "zo";
        };
      };
    };
  };
}
