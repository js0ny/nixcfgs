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
    search_url_d https://duckduckgo.com/?q=
  '';
  programs.sioyek = {
    enable = true;
    # prefs_user.config
    config.startup_commands = lib.mkForce [ "toggle_custom_color" ];
    bindings = {
      ## Movement
      "screen_down" = "<C-d>";
      "screen_up" = "<C-u>";

      "move_up_smooth" = "k";
      "move_down_smooth" = "j";
      "move_left_smooth" = "h";
      "move_right_smooth" = "l";
      ## Zoom

      "zoom_in" = "=";

      ## Highlight
      "add_highlight" = "H";

      ### Toggles
      "toggle_dark_mode" = [
        "i"
        ",D"
      ];
      "toggle_fullscreen" = ",f";
      "toggle_custom_color" = ",d";
      # toggle_dark_mode     D
      ## SyncTeX for LaTeX
      "toggle_synctex" = ",s";

      # Mark
      "goto_mark" = "'";

      ### Misc
      "quit" = "Q";

      "copy" = "yy";

      "goto_toc" = "<tab>";

      ## Smart Jump, Portals

      "overview_link" = "<C-p>";

      ## Muscle Memory Bindings

      "command" = "<A-x>";
      "search" = "<C-f>";
      "goto_next_tab" = "L";
      "goto_prev_tab" = "H";

      ## User Defined Commands
      "_copy_page_to_clipboard" = "<A-c>";
      "_copy_file_path" = "yf";
      "_dict" = "K";
    };
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
