{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    # Mimecraft launcher
    prismlauncher
  ];
  mergetools.prism-launcher-config = {
    target = "${config.home.homeDirectory}/.local/share/PrismLauncher/prismlauncher.cfg";
    format = "ini";
    force = true;
    settings = {
      General = {
        Language = "zh";
        ApplicationTheme = "Adwaita-Dark";
        ShowConsoleOnError = true;

        PermGen = 128;
        MinMemAlloc = 512;
        MaxMemAlloc = 4096;

        ShowGlobalGameTime = true;
        RecordGameTime = true;
        ShowGameTime = true;
        ShowGameTimeWithoutDays = true;
      };
    };
  };
  js0ny.persist.stores.state.directories = [ ".local/share/PrismLauncher" ];

}
