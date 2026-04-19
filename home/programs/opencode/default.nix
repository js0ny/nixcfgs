{ pkgs, inputs, ... }:
let
  system = pkgs.stdenv.system;
  opencodePkg = inputs.llm-agents.packages.${system}.opencode;
  # Wrap bun to perform plugin installation
  opencodeWithBun = pkgs.symlinkJoin {
    name = "opencode-with-bun";
    paths = [ opencodePkg ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/opencode" \
        --prefix PATH : ${
          pkgs.lib.makeBinPath [
            pkgs.bun
            pkgs.git
            pkgs.cacert
          ]
        } \
        --set BUN_TELEMETRY_DISABLED 1 \
        --set CI 1
    '';
  };
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
    package = opencodeWithBun;
    settings = {
      autoupdate = false;
      model = "openai/gpt-5.4";
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
