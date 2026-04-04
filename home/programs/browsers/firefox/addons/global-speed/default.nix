# TODO: Add options.nix and use it here.
{config, ...}: let
  id = "{f4961478-ac79-4a18-87e9-d2fb8c0442c4}";
  p = config.nixdots.programs.firefox.defaultProfile;
in {
  programs.firefox.profiles."${p}".extensionStorage."${id}".settings = {
    "g:config, firstUse" = 0;
    "g:keybinds" = [];
    "g:pageKeybinds" = [];
    "g:browserKeybinds" = [];
    "g:menuKeybinds" = [];
    "g:darkTheme" = true;
    "g:hideBadge" = false;
    "g:rules" = [
      {
        id = "1";
        enabled = true;
        type = "SPEED";
        overrideSpeed = 1;
        overrideJs = "// code here\n";
        condition = {
          blockPorts = [];
          allowParts = [
            {
              type = "CONTAINS";
              valueContains = "live.bilibili.com";
              valueStartsWith = "https://example.com";
              valueRegex = "example\\.com";
              id = "7329114269";
            }
            {
              type = "CONTAINS";
              valueContains = "twitch.tv";
              valueStartsWith = "https://example.com";
              valueRegex = "example\\.com";
              id = "2508547398";
            }
          ];
        };
        label = "直播网站";
        spacing = 1;
      }
      {
        id = "2";
        enabled = true;
        type = "SPEED";
        overrideSpeed = 1;
        overrideJs = "// code here\n";
        condition = {
          blockPorts = [];
          allowParts = [
            {
              type = "CONTAINS";
              valueContains = "music.apple.com";
              valueStartsWith = "https://example.com";
              valueRegex = "example\\.com";
              id = "8894008858";
            }
            {
              type = "CONTAINS";
              valueContains = "spotify.com";
              valueStartsWith = "https://example.com";
              valueRegex = "example\\.com";
              id = "1655154273";
            }
          ];
        };
        spacing = 1;
        label = "音频网站";
      }
      {
        id = "3";
        enabled = true;
        type = "SPEED";
        overrideSpeed = 1;
        overrideJs = "// Javascript here\n";
        condition = {
          blockPorts = [];
          allowParts = [
            {
              type = "STARTS_WITH";
              valueContains = "100.";
              valueStartsWith = "http://100";
              valueRegex = "example\\.com";
              id = "776710646";
            }
            {
              type = "CONTAINS";
              valueContains = "http://127.0.0.1";
              valueStartsWith = "https://example.com";
              valueRegex = "example\\.com";
              id = "6422057621";
            }
            {
              type = "CONTAINS";
              valueContains = "http://localhost";
              valueStartsWith = "https://example.com";
              valueRegex = "example\\.com";
              id = "8138815113";
            }
          ];
        };
        label = "localhost & tailnet";
      }
    ];
  };
}
