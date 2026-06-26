{
  config,
  lib,
  pkgs,
  ...
}:
let
  id = "{a8332c60-5b6d-41ee-bfc8-e9bb331d34ad}";
  pkg = pkgs.firefox-addons.surfingkeys_ff;
in
{
  imports = [
    ./lib.nix
  ];

  options.programs.firefox.profiles = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        {
          name,
          config,
          ...
        }:
        {
          options.surfingkeys = {
            enable = lib.mkEnableOption "Surfingkeys extension configuration";

            blocklist = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "A list of URLs or URL patterns where Surfingkeys should be disabled (mapped to 1 internally).";
              example = [
                "https://svelte.dev"
                "https://example.com"
              ];
            };

            showAdvanced = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Enable the advanced settings UI in Surfingkeys. Must be true to use `localPath` or `snippets`.";
              example = true;
            };

            localPath = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "The local file path or remote URL to load the Surfingkeys snippet from. Mutually exclusive with `snippets`.";
              example = "file:///home/user/.config/surfingkeys/config.js";
            };

            snippets = lib.mkOption {
              type = lib.types.lines;
              default = "";
              description = "Inline JavaScript configuration snippets for Surfingkeys. Mutually exclusive with `localPath`.";
              example = "api.unmap('j');\napi.unmap('k');";
            };
          };

          config = lib.mkIf config.surfingkeys.enable {
            assertions = [
              {
                assertion =
                  (config.surfingkeys.localPath != "" || config.surfingkeys.snippets != "")
                  -> config.surfingkeys.showAdvanced;
                message = "Firefox profile '${name}': `showAdvanced` must be true to use `localPath` or `snippets`.";
              }
              {
                assertion = !(config.surfingkeys.localPath != "" && config.surfingkeys.snippets != "");
                message = "Firefox profile '${name}': `localPath` and `snippets` are mutually exclusive.";
              }
            ];

            extensions.packages = [ pkg ];

            extensionStorage."${id}".settings = {
              # 使用 genAttrs 将 [ "url1" "url2" ] 转换为 { "url1" = 1; "url2" = 1; }
              blocklist = lib.genAttrs config.surfingkeys.blocklist (_: 1);
              showAdvanced = config.surfingkeys.showAdvanced;
              localPath = config.surfingkeys.localPath;
              snippets = config.surfingkeys.snippets;
            };
          };
        }
      )
    );
  };
}
