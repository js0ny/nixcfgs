{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (obsidian.override {
      commandLineArgs = "--password-store=gnome-libsecret";
      electron = pkgs.electron_39;
    })
  ];
  nixdots.persist.home = {
    directories = [
      "Obsidian"
      ".config/obsidian"
    ];
  };
}
