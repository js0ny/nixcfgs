{config, ...}: {
  home.username = config.nixdots.user.name;
  home.homeDirectory = config.nixdots.user.home;

  programs.home-manager.enable = true;

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  nixdots.persist.home = {
    directories = [
      ".ssh"
    ];
  };
}
