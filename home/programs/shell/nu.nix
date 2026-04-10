{ pkgs, ... }:
{
  programs.nushell = {
    enable = true;
    shellAliases = {
      "la" = "ls -a";
      "lt" = "lsd --tree";
      "l" = "ls -la";
      "ll" = "ls -l";
      "fg" = "job unfreeze";
    };
    extraConfig = ''
      $env.config.show_banner = false
      $env.config.history = {
        file_format: sqlite
        max_size: 1_000_000
        sync_on_enter: true
        isolation: true
      }
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/nix/nix-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/git/git-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/rg/rg-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/just/just-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/uv/uv-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/podman/podman-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/ssh/ssh-completions.nu
    '';
  };
  nixdots.persist.home = {
    directories = [
      ".config/nushell"
    ];
  };
}
