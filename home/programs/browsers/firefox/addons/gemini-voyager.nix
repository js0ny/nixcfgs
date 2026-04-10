{
  pkgs,
  config,
  ...
}:
let
  addons = pkgs.firefox-addons;

  p = config.nixdots.programs.firefox.defaultProfile;
in
{
  programs.firefox.profiles."${p}" = {
    extensionStorage."gemini-voyager@nagi-ovo".settings = {
      gvChangelogNotifyMode = "badge";
    };
    extensions.packages = with addons; [ gemini-voyager ];
  };
}
