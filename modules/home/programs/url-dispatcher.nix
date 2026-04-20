{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.programs.urlDispatcher;

  buildRegex = list: concatStringsSep "|" list;

  dispatcherScript = pkgs.writeShellApplication {
    name = "url-dispatcher";
    runtimeInputs = [
      pkgs.ripgrep
    ]
    ++ cfg.extraPackages;
    text = ''
      show_help() {
        cat <<EOF
      Usage: url-dispatcher [OPTIONS] <URL>

      Dispatch URLs to the appropriate browser based on configured rules.

      Options:
        -h, --help    Show this help message

      Behaviour:
        URLs matching the allow list are opened in the primary browser.
        URLs matching the deny list are opened in the isolated browser.
        Otherwise the default behaviour applies.
      EOF
        exit 0
      }

      case "''${1:-}" in
        -h|--help) show_help ;;
      esac

      URL="''${1:-}"
      [ -z "$URL" ] && show_help

      ${optionalString (length cfg.allowList > 0) ''
        if echo "$URL" | rg -q -i "(${buildRegex cfg.allowList})"; then
            exec ${cfg.defaultBrowser} "$URL"
        fi
      ''}

      ${optionalString (length cfg.denyList > 0) ''
        if echo "$URL" | rg -q -i "(${buildRegex cfg.denyList})"; then
            exec ${cfg.incognitoBrowser} "$URL"
        fi
      ''}

      ${
        if cfg.defaultBehaviour == "allow" then
          ''
            exec ${cfg.defaultBrowser} "$URL"
          ''
        else
          ''
            exec ${cfg.incognitoBrowser} "$URL"
          ''
      }
    '';
  };

in
{
  options.programs.urlDispatcher = {
    enable = mkEnableOption "Declarative URL Dispatcher";

    defaultBrowser = mkOption {
      type = types.str;
      default = "firefox";
      description = "Primary browser command (target for Allow)";
    };

    incognitoBrowser = mkOption {
      type = types.str;
      default = "chromium --incognito";
      description = "Command to invoke the isolated browser (for Deny targets)";
    };

    allowList = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "github\\.com"
        "nixos\\.org"
      ];
      description = "List of URL regex patterns to open in the primary browser";
    };

    denyList = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "tracking-domain\\.com"
        "example\\.org"
      ];
      description = "List of URL regex patterns to open in the isolated browser";
    };

    defaultBehaviour = mkOption {
      type = types.enum [
        "allow"
        "deny"
        "ask"
      ];
      default = "ask";
      description = "Default behaviour when no list is matched: allow (primary browser), deny (isolated browser), ask (Fuzzel prompt)";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional packages that custom commands may depend upon";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ dispatcherScript ];

    xdg.desktopEntries.url-dispatcher = {
      name = "URL Dispatcher";
      exec = "${dispatcherScript}/bin/url-dispatcher %U";
      terminal = false;
      categories = [
        "Network"
        "WebBrowser"
      ];
      mimeType = [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "url-dispatcher.desktop";
        "x-scheme-handler/http" = "url-dispatcher.desktop";
        "x-scheme-handler/https" = "url-dispatcher.desktop";
      };
    };
  };
}
