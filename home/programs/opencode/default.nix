{
  pkgs,
  inputs,
  config,
  ...
}:
let
  llm = config.nixdefs.llm;
in
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
      plugin = [
        "@mohak34/opencode-notifier@latest"
        "opencode-btw"
      ];
      permission = {
        bash = {
          "git commit*" = "ask";
          "git push*" = "deny";
          "git add*" = "ask";
          "git status" = "allow";
        };
        read = {
          "*" = "allow";
          "*.env" = "deny";
          "*.env.example" = "allow";
        };
      };
    };
  };

  nixdots.programs.shellAliases = {
    "oc" = "opencode";
  };
}
