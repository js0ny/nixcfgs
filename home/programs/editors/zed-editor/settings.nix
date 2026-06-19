{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.zed-editor = {
    userSettings = {
      icon_theme = "Material Icon Theme";
      tabs = {
        show_diagnostics = "errors";
        show_close_button = "hover";
        file_icons = true;
      };
      base_keymap = "VSCode";
      vim_mode = true;
      vim = {
        use_system_clipboard = "on_yank";
        use_smartcase_find = true;
        toggle_relative_line_numbers = true;
      };
      outline_panel = {
        dock = "right";
      };
      project_panel = {
        dock = "left";
      };
      git_panel = {
        dock = "left";
      };
      edit_predictions = {
        provider = "zed";
        disabled_globs = [
          "*.bean"
          "*.env"
          "secrets.yaml"
        ];
        copilot = {
          proxy = null;
          proxy_no_verify = null;
        };
      };
      # NOTE: managed by stylix
      # ui_font_size = 16;
      # buffer_font_size = null;
      # relative_line_numbers = true;
      # buffer_font_family = "Maple Mono NF CN";
      # theme = {
      #   mode = "system";
      #   light = "Catppuccin Latte";
      #   dark = "Catppuccin Mocha";
      # };
      remove_trailing_whitespace_on_save = true;
      inlay_hints = {
        enabled = true;
        show_type_hints = true;
        show_parameter_hints = true;
      };
      terminal = {
        copy_on_select = true;
        detect_venv = {
          on = {
            directories = [
              ".venv"
              "venv"
            ];
          };
        };
        dock = "bottom";
        option_as_meta = true;
      };
      file_types = {
        JSONC = [
          "*.code-snippets"
        ];
        Scheme = [ "*.kbd" ];
      };
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      languages = {
        Scheme.tab_size = 2;
        YAML = {
          tab_size = 2;
        };
        Nix = {
          tab_size = 2;
          formatter = {
            external = {
              command = lib.getExe pkgs.nixfmt;
              arguments = [
                "--quiet"
                "--"
              ];
            };
          };
          completions = {
            lsp_insert_mode = "replace";
          };
        };
        Lua = {
          tab_size = 2;
          formatter = {
            external = {
              command = "stylua";
            };
          };
        };
      };
      lsp = {
        nixd.settings = config.nixdefs.lsp.servers.nixd.serverSettings;
        lua-language-server.settings = config.nixdefs.lsp.servers.lua-language-server.serverSettings;
      };
      cli_default_open_behavior = "existing_window";
      agent = {
        dock = "right";
      };
    };
  };
}
