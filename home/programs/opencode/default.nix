{
  pkgs,
  config,
  secrets,
  ...
}:
let
  sopsFile = secrets + /opencode.yaml;
in
{
  imports = [
    ./integrations.nix
  ];
  sops.secrets = {
    llm_key_opencode = {
      sopsFile = sopsFile;
    };
    opencode_web_username = {
      sopsFile = sopsFile;
    };
    opencode_web_password = {
      sopsFile = sopsFile;
    };
  };

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

  sops.templates."opencode-web.env".content = /* bash */ ''
    OPENCODE_SERVER_USERNAME=${config.sops.placeholder.opencode_web_username}
    OPENCODE_SERVER_PASSWORD=${config.sops.placeholder.opencode_web_password}
  '';

  programs.opencode = {
    enable = true;
    web = {
      enable = true;
      environmentFile = config.sops.templates."opencode-web.env".path;
    };
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
          "*.env" = "deny";
          "*.env.example" = "allow";
          "sops -d*" = "deny";
          "sops --decrypt*" = "deny";
          "sops*" = "ask";
        };
        read = {
          "*" = "allow";
          "*.env" = "deny";
          "*.env.example" = "allow";
        };
        external_directory = {
          "/nix/store/**" = "allow";
        };
      };
    };
  };

  misc.shellAliases = {
    "oc" = "opencode";
  };
}
