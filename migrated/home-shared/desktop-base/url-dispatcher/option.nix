{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.programs.urlDispatcher;

  dispatcherScript =
    pkgs.writers.writeNuBin "url-dispatcher"
      {
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          (lib.makeBinPath ([ pkgs.ripgrep ] ++ cfg.extraPackages))
        ];
      }
      /* nu */ ''
        def matches [url: string, patterns: list<string>] {
          if ($patterns | is-empty) {
            return false
          }
          let regex = $patterns | str join "|"
          let result = $url | ^rg -q -i $"(($regex))" | complete
          $result.exit_code == 0
        }

        # Dispatch a URL to the appropriate browser.
        def main [url?: string] {
          let settings = ${
            builtins.toJSON {
              inherit (cfg)
                trusted
                untrusted
                defaultBrowser
                incognitoBrowser
                defaultBehaviour
                echoEnv
                ;
            }
          }

          if ($url | is-empty) {
            print "Usage: url-dispatcher [OPTIONS] <URL>"
            return
          }

          if ($settings.echoEnv | any {|name| $name in $env }) {
            print $url
            return
          }

          let browser = if (matches $url $settings.trusted) {
            $settings.defaultBrowser
          } else if (matches $url $settings.untrusted) {
            $settings.incognitoBrowser
          } else if $settings.defaultBehaviour == "allow" {
            $settings.defaultBrowser
          } else {
            $settings.incognitoBrowser
          }

          exec $browser.0 ...($browser | skip 1) $url
        }
      '';

in
{
  options.programs.urlDispatcher = {
    enable = mkEnableOption "Declarative URL Dispatcher";

    defaultBrowser = mkOption {
      type = types.nonEmptyListOf types.str;
      default = [ "firefox" ];
      description = "Primary browser command and arguments (target for Allow)";
    };

    incognitoBrowser = mkOption {
      type = types.nonEmptyListOf types.str;
      default = [
        "chromium"
        "--incognito"
      ];
      description = "Isolated browser command and arguments (for Deny targets)";
    };

    trusted = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "github\\.com"
        "nixos\\.org"
      ];
      description = "List of URL regex patterns to open in the primary browser";
    };

    untrusted = mkOption {
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
      ];
      default = "allow";
      description = "Default behaviour when no list is matched: allow (primary browser), deny (isolated browser), ask (Fuzzel prompt)";
    };

    echoEnv = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Environment variables that cause the URL to be printed instead of opened when present";
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
      exec = "${lib.getExe dispatcherScript} %U";
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
