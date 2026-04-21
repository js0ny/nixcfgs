{ config, ... }:
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
      };
      outline_panel = {
        dock = "right";
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
      agent = {
        default_model = {
          provider = "openrouter";
          model = "openai/gpt-5.1-codex";
        };
      };
      inlay_hints = {
        enabled = true;
        show_type_hints = true;
        show_parameter_hints = true;
      };
      terminal = {
        detect_venv = {
          on = {
            directories = [
              ".venv"
            ];
          };
        };
        dock = "bottom";
        env = {
          EDITOR = "zeditor --wait";
        };
        shell = {
          program = "zsh";
        };
        option_as_meta = true;
      };
      file_types = {
        JSON = [
          "*.code-snippets"
        ];
      };
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      languages = {
        YAML = {
          tab_size = 2;
        };
        Nix = {
          tab_size = 2;
          formatter = {
            external = {
              command = "nixfmt";
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
      context_servers = removeAttrs config.nixdefs.mcp.servers [ "type" ];
    };
  };
}
