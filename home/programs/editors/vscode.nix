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
    package = pkgs.vscode-fhs;
    enable = true;
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
