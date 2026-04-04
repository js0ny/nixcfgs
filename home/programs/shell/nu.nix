{...}: {
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
    '';
  };
  nixdots.persist.home = {
    directories = [
      ".config/nushell"
    ];
  };
}
