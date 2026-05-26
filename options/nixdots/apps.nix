{
  pkgs,
  lib,
  config,
  ...
}:
let
  types = import ./types.nix { inherit lib; };
  appType = types.appType;
in
{
  options.nixdots.apps = {
    terminal = lib.mkOption {
      type = appType;
      default = {
        package = pkgs.kitty;
        exe = "kitty";
        desktop = "kitty.desktop";
        bundleIdentifier = "net.kovidgoyal.kitty";
      };
    };
    interactiveShell = lib.mkOption {
      type = appType;
      default = {
        package = config.nixdots.user.shell;
        exe = lib.getExe config.nixdots.user.shell;
        desktop = "";
        bundleIdentifier = "";
      };
    };
    browser = lib.mkOption {
      type = appType;
      default = {
        package = pkgs.firefox;
        exe = "firefox";
        desktop = "firefox.desktop";
        bundleIdentifier = "org.mozilla.firefox";
      };
    };
    fileManager = {
      gui = lib.mkOption {
        type = appType;
        default = {
          package = pkgs.thunar;
          exe = "thunar";
          desktop = "Thunar.desktop";
          bundleIdentifier = "";
        };
      };
      tui = lib.mkOption {
        type = appType;
        default = {
          package = pkgs.yazi;
          exe = "yazi";
          desktop = "yazi.desktop";
          bundleIdentifier = "";
        };
      };
    };
    editor = {
      tui = lib.mkOption {
        type = appType;
        default = {
          package = pkgs.vim;
          exe = "vim";
          desktop = "vim.desktop";
          bundleIdentifier = "";
        };
      };
      gui = lib.mkOption {
        type = appType;
        default = {
          package = pkgs.vim;
          exe = "vim";
          desktop = "vim.desktop";
          bundleIdentifier = "";
        };
      };
    };
  };
}
