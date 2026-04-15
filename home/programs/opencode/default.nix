{ pkgs, ... }:
{
  xdg.configFile."opencode/oh-my-opencode.json".text = builtins.toJSON (import ./oh-my-openagent.nix);

  nixdots.persist.home = {
    directories = [
      ".local/share/opencode"
      ".config/opencode"
    ];
  };

  home.sessionVariables = {
    # Manage LSP by DevShell
    OPENCODE_DISABLE_LSP_DOWNLOAD = if pkgs.stdenv.isLinux then "true" else "";
  };

  programs.opencode = {
    enable = true;
    settings = {
      autoupdate = false;
      model = "openai/gpt-5.4";
    };
  };

  nixdots.programs.shellAliases = {
    "oc" = "opencode";
  };
}
