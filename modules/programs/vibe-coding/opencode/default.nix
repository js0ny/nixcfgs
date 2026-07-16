{
  flake.homeModules.opencode =
    {
      pkgs,
      lib,
      config,
      secrets,
      ...
    }:
    let
      sopsFile = secrets + /opencode.yaml;
      user = config.home.username;
    in
    {
      home.packages = lib.optionals config.nixdots.desktop.enable [ pkgs.opencode-desktop ];
      imports = [
        ./integrations.nix
      ];
      sops.secrets = {
        llm_key_opencode = { inherit sopsFile; };
        opencode_web_username = { inherit sopsFile; };
        opencode_web_password = { inherit sopsFile; };
      };

      nixdots.persist.nosnap.home = {
        directories = [
          ".local/share/opencode"
        ];
      };
      nixdots.persist.home.directories = [ ".config/opencode" ];
      systemd.user.tmpfiles.rules = [
        "f ${config.xdg.dataHome}/opencode/auth.json 0600 ${user} users -"
      ];

      home.sessionVariables = {
        # Manage LSP by DevShell
        OPENCODE_DISABLE_LSP_DOWNLOAD = if pkgs.stdenv.isLinux then "true" else "";
      };

      sops.templates."opencode-web.env".content = /* bash */ ''
        OPENCODE_SERVER_USERNAME=${config.sops.placeholder.opencode_web_username}
        OPENCODE_SERVER_PASSWORD=${config.sops.placeholder.opencode_web_password}
      '';

      programs.zsh.initContent = /* bash */ ''
        source <(opencode completion)
      '';

      programs.opencode = {
        enable = true;
        web = {
          enable = false;
          environmentFile = config.sops.templates."opencode-web.env".path;
        };
        # https://opencode.ai/docs/config/
        settings = {
          model = "openai/gpt-5.6-sol";
          agent = {
            "yolo" = {
              mode = "primary";
              model = "openai/gpt-5.5";
              permission = {
                bash = "allow";
                edit = "allow";
                read = "allow";
              };
            };
          };
          plugin = [
            "@mohak34/opencode-notifier@latest"
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
              "rm*" = "ask";
              "srm*" = "ask";
              "rip*" = "ask";
              ",*" = "ask";
              "nix run*" = "ask";
              "npx*" = "ask";
              "uvx*" = "ask";
              "ssh*" = "ask";
            };
            read = {
              "*" = "allow";
              "*.env" = "deny";
              "*.env.example" = "allow";
            };
            external_directory = {
              "/nix/store/**" = "allow";
              "/tmp/**" = "allow";
            };
          };
          lsp = {
            qml = {
              command = [ "qmlls" ];
              extensions = [ "qml" ];
            };
          };
        };
      };

      misc.shellAliases = {
        "oc" = "opencode";
      };
    };
}
