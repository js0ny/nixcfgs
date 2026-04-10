{ lib }:
with lib;
{
  # 接收一个 name 和一个配置集，返回能够直接并入 Home Manager 配置的 AttrSet
  mkDolphinService =
    name:
    {
      mimeType ? "all/allfiles", # 默认匹配所有文件
      icon ? "system-run",
      desktopEntryExtra ? { },
      actionOrder ? null,
      actions,
    }:
    let
      # 提取所有 action 的键名，用分号连接 (Dolphin 规范)
      actionKeys =
        concatStringsSep ";" (if actionOrder != null then actionOrder else attrNames actions) + ";";

      mkActionEntry =
        actionConfig:
        let
          extraFields = actionConfig.extraFields or { };
        in
        extraFields
        // optionalAttrs (actionConfig ? name) { Name = actionConfig.name; }
        // optionalAttrs (actionConfig ? exec) { Exec = actionConfig.exec; }
        // optionalAttrs (actionConfig ? icon) { Icon = actionConfig.icon; }
        // optionalAttrs (!(actionConfig ? icon) && !(actionConfig ? Icon)) { Icon = icon; };

      # 构建主 [Desktop Entry]
      mainEntry = {
        "Desktop Entry" = {
          Type = "Service";
          MimeType = mimeType;
          Actions = actionKeys;
          Icon = icon;
        }
        // desktopEntryExtra;
      };

      # 构建各个 [Desktop Action xxx]
      actionEntries = mapAttrs' (
        actionName: actionConfig: nameValuePair "Desktop Action ${actionName}" (mkActionEntry actionConfig)
      ) actions;

      # 合并主入口和各个 action
      iniContent = mainEntry // actionEntries;
    in
    {
      # 利用 xdg.dataFile 直接将文件放入 ~/.local/share/kio/servicemenus/
      xdg.dataFile."kio/servicemenus/${name}.desktop".text = generators.toINI { } iniContent;
    };
}
