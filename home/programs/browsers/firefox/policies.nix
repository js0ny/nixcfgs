{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  programs.firefox.policies = {
    DisableTelemetry = true;
    BlockAboutConfig = false;
    DisableFirefoxScreenshots = true;
    DontCheckDefaultBrowser = true;

    ExtensionSettings =
      with builtins;
      let
        extension = short: uuid: {
          name = uuid;
          value = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
        };
      in
      listToAttrs [
        (extension "ublock-origin" "uBlock0@raymondhill.net")
        (extension "multi-account-containers" "@testpilot-containers")
        (extension "side-view" "@webcompat@mozilla.org")
        (extension "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
      ];

    SearchEngines = {
      Default = "DuckDuckGo";
      Add = [
        {
          Alias = "np";
          Description = "Search in NixOS Packages";
          IconURL = "https://nixos.org/favicon.ico";
          Method = "GET";
          Name = "NixOS Packages";
          URLTemplate = "https://search.nixos.org/packages?from=0&size=200&sort=relevance&type=packages&query={searchTerms}";
        }
        {
          Alias = "no";
          Description = "Search in NixOS Options";
          IconURL = "https://nixos.org/favicon.ico";
          Method = "GET";
          Name = "NixOS Options";
          URLTemplate = "https://search.nixos.org/options?from=0&size=200&sort=relevance&type=packages&query={searchTerms}";
        }
        {
          Alias = "hm";
          Description = "Search in Home Manager Options";
          IconURL = "https://nixos.org/favicon.ico";
          Method = "GET";
          Name = "Home Manager options";
          URLTemplate = "https://home-manager-options.extranix.com/?query={searchTerms}";
        }
      ];
    };
  };

}
