{
  config,
  pkgs,
  ...
}:
{
  imports = [ ../../sandboxed.nix ];
  systemd.user.tmpfiles.rules = [
    "d ${config.home.homeDirectory}/.sandbox/.per-app/wechat 0700 ${config.home.username} users -"
  ];
  home.packages = with pkgs; [
    (nixpaks.wechat.override {
      package = pkgs.wechat;
      wechatDataDir = ".sandbox/.per-app/wechat/Documents/WeChat_Data";
      xwechatDir = ".sandbox/.per-app/wechat/.xwechat";
      xwechatFilesDir = ".sandbox/.per-app/wechat/xwechat_files";
      extraPackages = with pkgs; [ kdePackages.kde-cli-tools ];
      fontPackages = with pkgs; [
        maple-mono.NF-CN
        lxgw-neoxihei
      ];

      fontAliases = {
        "sans-serif" = [ "LXGW Neo XiHei" ];
        "system-ui" = [ "LXGW Neo XiHei" ];
        monospace = [ "Maple Mono NF CN" ];
      };
    })
  ];
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
