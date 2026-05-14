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
}
