{
  pkgs,
  config,
  lib,
  ...
}:
let
  sioyekCopyScript = pkgs.writeShellApplication {
    name = "sioyek-copy-page";
    runtimeInputs =
      with pkgs;
      [ poppler-utils ]
      ++ (
        if pkgs.stdenv.isLinux then
          with pkgs;
          [
            wl-clipboard
            libnotify
          ]
        else
          [ ]
      );
    text = builtins.readFile ./sioyek-copy-page.sh;
  };
  clip = if pkgs.stdenv.isLinux then "wl-copy" else "pbcopy";
in
{
  xdg.configFile."sioyek/prefs_user.config".text = ''
    new_command _copy_page_to_clipboard ${lib.getExe sioyekCopyScript} %{page_number} %{file_path}
    new_command _copy_file_path  ${clip} "%{file_path}"
    default_dark_mode 1
    font_size 14
    case_sensitive_search 0
    super_fast_search 1
    should_launch_new_window 1
    search_url_d https://duckduckgo.com/?q=
  '';
  xdg.configFile."sioyek/keys_user.config".source = ./keys_user.config;
  programs.sioyek = {
    enable = true;
    config.startup_commands = lib.mkForce [ "toggle_custom_color" ];
  };
  nixdots.persist.home = {
    directories = [
      # annotations
      ".local/share/sioyek"
    ];
  };
  catppuccin = {
    enable = false;
    flavor = "mocha";
    accent = "pink";
    sioyek.enable = true; # Stylix does not support sioyek yet, use ctpn as fallback
  };
}
