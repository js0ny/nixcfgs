{ pkgs, inputs, ... }:
let
  profileName = "js0ny";
  sharedPath = "${inputs.self.outPath}/migrated/shared-modules/firefox";
  policies = import "${sharedPath}/policies/vanilla.nix";
in
{
  imports = [
    inputs.zen-browser.homeModules.default
    ./containers.nix
  ];

  js0ny.persist.stores.state.directories = [ ".config/zen" ];

  programs.zen-browser = {
    enable = true;
    policies = policies // {
      "3rdparty".Extensions = {
        "uBlock0@raymondhill.net" = import "${sharedPath}/policies/ublock-origin.nix";
        "containerise-managed@js0ny.net" = import "${sharedPath}/policies/containerise.nix";
      };
    };
    profiles.js0ny = {
      name = profileName;
      isDefault = true;
      presets = {
        catppuccin = {
          enable = false;
          accent = "Lavender";
          flavor = "Mocha";
        };
        betterfox.enable = true;
      };
      settings = {
        "zen.welcome-screen.seen" = true;
      };
      extensions = {
        packages = with pkgs.firefox-addons; [
          pkgs.js0ny.containerise-managed
          surfingkeys_ff
          violentmonkey
          ublock-origin
          global-speed

          # Cookies
          cookie-quick-manager
          istilldontcareaboutcookies

          # github.com
          material-icons-for-github
          refined-github-
          # s.team
          steam-database
          protondb-for-steam
          # youtu.be
          return-youtube-dislikes
          sponsorblock
          # bilibili.com
          bilisponsorblock

          rsshub-radar
          proton-pass
          proton-vpn-firefox-extension
          styl-us
          kiss-translator
          auto-tab-discard
          gesturefy
          karakeep
          leechblock-ng
          copy-latex
        ];
      };
    };
  };

  xdg.configFile."zen/${profileName}/customKeys.json".source = ./customKeys.json;
}
