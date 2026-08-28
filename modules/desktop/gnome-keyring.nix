{ pkgs, lib, ... }:
{
  programs.gnupg.agent.enableSSHSupport = false;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = true;
  programs.seahorse.enable = true;
  programs.ssh = {
    enableAskPassword = true;
    askPassword = "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
  };
  security.pam.services = {
    gdm-password.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;
    login.kwallet.enable = lib.mkForce false;
    kde.kwallet.enable = lib.mkForce false;
  };
  home-manager.sharedModules = [
    {
      nixdots.persist.home = {
        directories = [ ".local/share/keyrings" ];
      };
      services.gnome-keyring.enable = lib.mkForce false;
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
  ];
}
