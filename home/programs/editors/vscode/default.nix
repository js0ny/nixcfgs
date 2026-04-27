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
  snippets = (import ../lsp-snippets { inherit pkgs config; }).raw;
  dots = config.nixdots.core.dots;
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [ ../. ];
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
      "workbench.iconTheme" = "material-icon-theme";
      "editor.lineNumbers" = "relative";
      "nix.serverSettings".nixd = config.nixdefs.lsp.servers.nixd.serverSettings;
      "vim.vimrc.enable" = true;
      "vim.vimrc.path" = ./vscode.vim;
      "vim.hlsearch" = true;
      "vim.useSystemClipboard" = true;
      "vim.smartRelativeLine" = true;
      "vim.useCtrlKeys" = false;
      "hsnips.linux" = ./hsnips;
      "hsnips.mac" = ./hsnips;
    };
  };

  # Remove default snippet dir before running this to avoid conflicts
  # Textmate snippets
  xdg.configFile =
    builtins.listToAttrs (
      map (dir: {
        name = "${dir}/User/snippets";
        value = {
          source = snippets;
          force = true;
          # recursive = true;
        };
      }) codeReleasesConfigDir
    )
    // {
      "Code/User/keybindings.json".source =
        mkSymlink "${dots}/home/programs/editors/vscode/keybindings-linux-win.jsonc";
    };

  catppuccin.vscode.profiles.default.enable = false;
  nixdots.programs.shellAliases = codeAlias;
}
