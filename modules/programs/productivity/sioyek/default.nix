{
  flake.homeModules = {
    sioyek =
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
              if pkgs.stdenv.hostPlatform.isLinux then
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
        clip = if pkgs.stdenv.hostPlatform.isLinux then "wl-copy" else "pbcopy";
        sioyekDualPanelify = pkgs.writeShellApplication {
          name = "sioyek-dual-panelify";

          runtimeInputs = [
            pkgs.uv
          ];

          text = ''
            export LD_LIBRARY_PATH="${
              pkgs.lib.makeLibraryPath [
                pkgs.stdenv.cc.cc.lib
                pkgs.krb5
                pkgs.glib
              ]
            }''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

            exec ${lib.getExe pkgs.uv} run \
              --no-project \
              --with ${pkgs.js0ny.sioyek-python-extensions} \
              python -m sioyek.dual_panelify "$@"
          '';
        };
      in
      {
        xdg.configFile."sioyek/prefs_user.config".text = ''
          new_command _copy_page_to_clipboard ${lib.getExe sioyekCopyScript} %{page_number} %{file_path}
          new_command _copy_file_path  ${clip} "%{file_path}"
          new_command _dual_panelify ${lib.getExe sioyekDualPanelify} "%{sioyek_path}" "%{file_path}" "%{command_text}"
          default_dark_mode 1
          font_size 14
          case_sensitive_search 0
          super_fast_search 1
          should_launch_new_window 1
          search_url_d https://duckduckgo.com/?q=
          show_document_name_in_statusbar 1
          status_bar_format  Page %{current_page} / %{num_pages}%{chapter_name}%{search_results}%{search_progress}%{link_status}%{waiting_for_symbol}%{indexing}%{preview_index}%{synctex}%{drag}%{presentation}%{visual_scroll}%{locked_scroll}%{highlight}%{closest_bookmark}%{close_portal}%{rect_select}%{custom_message}%{document_name}
          status_font ${(builtins.head config.nixdots.style.fonts.displayMono).name}
        '';
        xdg.configFile."sioyek/keys_user.config".source = ./keys_user.config;
        programs.sioyek = {
          enable = true; # use flatpak
          config.startup_commands = lib.mkForce [ "toggle_custom_color" ];
        };
        nixdots.persist.home = {
          directories = [
            # annotations
            ".local/share/sioyek"
          ];
        };
      };
    desktop = { inputs, ... }: {
      imports = [ inputs.self.homeModules.sioyek ];
    };
  };
}
