{
  pkgs,
  config,
  ...
}:
let
  codeAlias = {
    "c" = "code";
  };
  codeReleasesConfigDir = [
    "Code"
  ];
  snippets = (import ./lsp-snippets { inherit pkgs config; }).raw;
in
{
  imports = [ ./default.nix ];
  programs.vscode = {
    enable = true;
    package = (
      pkgs.vscode.override {
        commandLineArgs = "--password-store=gnome-libsecret";
      }
    );
  };

  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      pkief.material-icon-theme
      vscodevim.vim
      vspacecode.vspacecode
      vspacecode.whichkey
      christian-kohler.path-intellisense
    ];
    userSettings = {
      workbench.iconTheme = "material-icon-theme";
      nix.serverSettings.nixd = config.nixdefs.lsp.servers.nixd.serverSettings;
    };
  };

  # Remove default snippet dir before running this to avoid conflicts
  # Textmate snippets
  xdg.configFile = builtins.listToAttrs (
    map (dir: {
      name = "${dir}/User/snippets";
      value = {
        source = snippets;
        force = true;
        # recursive = true;
      };
    }) codeReleasesConfigDir
  );

  catppuccin.vscode.profiles.default.enable = false;
  nixdots.programs.shellAliases = codeAlias;
}
