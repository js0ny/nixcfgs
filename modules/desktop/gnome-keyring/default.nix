{
  flake = {
    nixosModules = {
      gnome-keyring =
        { pkgs, ... }:
        {
          programs.gnupg.agent.enableSSHSupport = false;
          services.gnome.gnome-keyring.enable = true;
          services.gnome.gcr-ssh-agent.enable = true;
          programs.seahorse.enable = true;
          programs.ssh = {
            enableAskPassword = true;
            askPassword = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
          };
          security.pam.services.gdm-password.enableGnomeKeyring = true;
          security.pam.services.login.enableGnomeKeyring = true;
        };
      desktop = { inputs, ... }: {
        imports = [ inputs.self.nixosModules.gnome-keyring ];
      };
    };
    homeModules = {
      gnome-keyring =
        {
          pkgs,
          lib,
          config,
          ...
        }:
        lib.mkMerge [
          {
            nixdots.persist.home = {
              directories = [ ".local/share/keyrings" ];
            };
            # Disable KDE Wallet
            xdg.configFile."kwalletrc".text = lib.generators.toINI { } {
              Wallet = {
                "Close When Idle" = false;
                "Close on Screensaver" = false;
                "Default Wallet" = "kdewallet";
                "Enabled" = false;
                "Idle Timeout" = 10;
                "Launch Manager" = false;
                "Leave Manager Open" = false;
                "Leave Open" = true;
                "Prompt on Open" = false;
                "Use One Wallet" = true;
              };
              "org.freedesktop.secrets".apiEnabled = true;
            };
          }
          (lib.mkIf (pkgs.stdenv.isLinux && !config.nixdots.linux.nixos) {
            services.gnome-keyring.enable = true;
          })
        ];
      desktop = { inputs, ... }: {
        imports = [ inputs.self.homeModules.gnome-keyring ];
      };
    };

  };

}
