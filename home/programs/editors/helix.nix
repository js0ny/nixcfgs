{ pkgs, config, ... }:
let
  lsp = config.nixdefs.lsp.servers;
  nixd = lsp.nixd.serverSettings;
in
{
  programs.helix = {
    enable = true;
    languages.language-server = {
      nixd.config.nixd = nixd;
    };
    settings = {
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
        bufferline = "always";
      };
      keys.normal = {
        space.space = "file_picker";
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
      };
    };
    languages = {
      auto-format = true;
      language = [
        {
          auto-format = true;
          name = "nix";
          formatter.command = "nixfmt";
        }
      ];
    };
  };
  imports = [ ./. ];
}
