# nixpaks

基于 [nixpak](https://github.com/nixpak/nixpak) 的应用沙箱配置，使用 bubblewrap + xdg-dbus-proxy 隔离不可信应用。

## 目录结构

```
├── default.nix          # overlay 入口，导出 nixpaks 命名空间
├── modules/
│   ├── common.nix       # 通用沙箱策略（D-Bus、Portal、XDG 目录映射）
│   ├── gui-base.nix     # GUI 基础（GPU、字体、Wayland/PulseAudio、主题）
│   └── network.nix      # 网络访问（SSL 证书、DNS）
├── qq.nix
├── discord.nix
├── spotify.nix
├── termius.nix
├── ticktick.nix
├── zoom-us.nix
└── feishin.nix
```

## 数据目录映射

沙箱内的应用看到的始终是标准 XDG 路径，但宿主机上的物理存储位置取决于 `flatpakDataDir` 选项：

### `flatpakDataDir = true`（Flatpak 隔离模式）

沿用 Flatpak 约定，数据存放在 `~/.var/app/${appId}/` 下：

| 宿主机路径                   | 沙箱内路径        |
| ---------------------------- | ----------------- |
| `~/.var/app/${appId}/data`   | `~/.local/share`  |
| `~/.var/app/${appId}/config` | `~/.local/config` |
| `~/.var/app/${appId}/cache`  | `~/.local/cache`  |

每个应用独占子树，互不干扰。

### `flatpakDataDir = false`（默认，细粒度模式）

数据直接存放在标准 XDG 目录下，通过 `xdgBind` 按子目录名精确映射：

```nix
flatpakDataDir = false;
xdgBind = {
  data   = [ "AppFoo" ];    # 宿主 ~/.local/share/AppFoo → 沙箱 ~/.local/share/AppFoo
  config = [ "AppFoo" ];    # 宿主 ~/.config/AppFoo     → 沙箱 ~/.config/AppFoo
  cache  = [ "AppFoo" ];    # 宿主 ~/.cache/AppFoo      → 沙箱 ~/.cache/AppFoo
};
```

未在 `xdgBind` 中声明的子目录对沙箱不可见，实现最小权限。

### 当前偏好约定

本仓库默认优先使用标准 XDG 目录映射（`flatpakDataDir = false` + `xdgBind`），避免把配置落到 `~/.var/app/*`。

## 添加新沙箱

### Flatpak manifest 参考

新建或维护某个应用的 nixpak 时，优先参考对应 Flathub manifest 的 `finish-args`，将权限逐项映射到 `dbus.policies`、`bubblewrap.sockets`、`bubblewrap.bind` 等字段。

- Discord: https://github.com/flathub/com.discordapp.Discord/blob/master/com.discordapp.Discord.json

建议在每个应用文件顶部保留 manifest 链接注释，便于后续 session 快速追溯权限来源。

```nix
# example.nix
{ lib, pkgs, mkNixPak, buildEnv, makeDesktopItem, ... }:
let
  appId = "com.example.App";

  wrapped = mkNixPak {
    config = { sloth, ... }: {
      app = {
        package = buildEnv {
          name = "nixpak-example";
          paths = [ pkgs.example-app ];
        };
        binPath = "bin/example";
      };
      flatpak.appId = appId;

      # 二选一：
      # 方案 A：Flatpak 隔离（适合不信任的应用）
      flatpakDataDir = true;
      # 方案 B：细粒度映射（需要控制哪些目录可写）
      # flatpakDataDir = false;
      # xdgBind.data = [ "ExampleApp" ];
      # xdgBind.config = [ "ExampleApp" ];
      # xdgBind.cache = [ "ExampleApp" ];

      imports = [
        ./modules/gui-base.nix
        ./modules/network.nix
        ./modules/common.nix
      ];

      bubblewrap = {
        bind.rw = [
          [ (sloth.concat' sloth.homeDir "/.sandbox/downloads") sloth.xdgDownloadDir ]
        ];
        sockets = { wayland = true; pipewire = true; };
      };
    };
  };
  exePath = lib.getExe wrapped.config.script;
in
buildEnv {
  inherit (wrapped.config.script) name meta passthru;
  paths = [
    wrapped.config.script
    (makeDesktopItem {
      name = appId;
      desktopName = "Example";
      exec = "${exePath} %U";
      terminal = false;
      icon = "example";
      type = "Application";
      categories = [ "Utility" ];
      extraConfig.X-Flatpak = appId;
    })
  ];
}
```

然后在 `default.nix` 的 overlay 中注册即可。

## Electron 应用注意事项

Electron 应用将所有用户数据写入 XDG config 目录（`~/.config/<AppName>`），不会写 XDG data 或 cache 目录。因此 `xdgBind` 只需 bind `config`，无需 bind `data` 和 `cache`。
