{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # Nintendo Switch Emulator
    ryubing
  ];
  mergetools.ryujinx-config = {
    target = "${config.home.homeDirectory}/.config/Ryujinx/Config.json";
    format = "json";
    settings = {
      game_dir = [
        "${config.home.homeDirectory}/Games/ROM/Nintendo - Nintendo Switch"
      ];
      "language_code" = "zh_CN";
      "check_updates_on_start" = false;
    };
  };
}
