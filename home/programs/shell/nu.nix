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
      "cls" = "clear";
    };
    extraConfig = /* nu */ ''
      $env.config.show_banner = false
      $env.config.history = {
        file_format: sqlite
        max_size: 1_000_000
        sync_on_enter: true
        isolation: true
      }
      $env.config.keybindings ++= [
        {
          name: insert_last_token
          modifier: alt
          keycode: char_.
          mode: emacs
          event: [
            { edit: InsertString, value: " !$" }
            { send: Enter }
          ]
        }]
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/nix/nix-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/git/git-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/rg/rg-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/just/just-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/uv/uv-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/podman/podman-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/ssh/ssh-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/zellij/zellij-completions.nu
    '';
  };
  nixdots.persist.home = {
    directories = [
      ".config/nushell"
    ];
  };
}
