{
  config,
  pkgs,
  ...
}:
{
  imports = [ ../sandboxed.nix ];
  systemd.user.tmpfiles.rules = [
    "d ${config.home.homeDirectory}/.sandbox/.per-app/wechat 0700 ${config.home.username} users -"
  ];
  home.packages = with pkgs; [
    localPkgs.wechat-bwrap
  ];
  nixdots.persist.home = {
    directories = [
      ".sandbox/.per-app/wechat"
    ];
  };
  services.xremap.config.keymap = [
    {
      name = "IM Navigator - Alt-Up/Down";
      application = {
        only = [ "wechat" ];
      };
      remap = {
        "M-j" = "M-down";
        "M-k" = "M-up";
      };
    }
  ];
}
