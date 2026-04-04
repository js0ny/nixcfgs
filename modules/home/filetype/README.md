# 系统文件类型与 MIME 配置 (Filetype Module)

本模块用于在 NixOS 系统级别统一管理和拓展自定义文件格式的识别逻辑，
确保桌面环境与终端工具链能够准确解析小众或专有文件类型。

## 目录结构

* `default.nix`: 模块主入口，负责导出配置。
* `libmagic.nix`: 针对 CLI 场景的底层 `file` 命令特征码配置。
* `mimedb.nix`: 负责将自定义 XML 注入到 Home Manager 的 `xdg.dataFile` 中并触发数据库更新。
* `mimepkgs/`: 存放按领域划分的 FreeDesktop `shared-mime-info` XML 规范文件。由 `mimedb.nix` 统一管理和注入。

---

## 编写自定义 MIME XML 规范 (`mimepkgs/`)

当需要为新的游戏资产、专有配置或开发文件添加桌面环境级的 MIME 识别时，请遵循以下规范在 `mimepkgs/` 中新增或修改 XML 文件。

### 1. 文件组织：按领域合并

避免为每一个单独的扩展名创建独立的 XML 文件。应将逻辑相关的格式归类到同一个域（Domain）下，以保持代码整洁。

* **示例：** `games.xml` (包含 `.pck`, `.vdf`, `.cia` 等), `development.xml` (包含 `.nix`, `.xdc` 等)。

### 2. 命名空间约定：优先使用 `x-` 前缀

虽然 IANA 现代规范推荐私有格式使用 `vnd.` 供应商前缀，但在 GNU/Linux 桌面生态中，作为系统的**本地识别补丁**，强制推荐使用 `x-` 前缀。

* **规范：** `主类型/x-格式名`
* **示例：** `application/x-godot-pack` 或 `text/x-valve-vdf`
* **原因：** 这能最大程度兼容现有的底层解析工具，并确保诸如 Papirus 等主流图标主题包能够正确匹配并渲染出对应格式的图标。

### 3. XML 结构模板

```xml
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  
  <mime-type type="application/x-example-format">
    <comment>Example Package</comment>
    <comment xml:lang="zh_CN">示例包</comment>
    
    <acronym>EXP</acronym>
    
    <glob pattern="*.exp"/>
    
    <generic-icon name="package-x-generic"/>
    
    <magic priority="50">
      <match type="string" value="EXMP" offset="0"/>
    </magic>
  </mime-type>

</mime-info>
```

### 4. 参考命令

使用 `xdg-mime` 工具测试 MIME 类型识别： `(pkgs.xdg-utils)`

```bash
xdg-mime query filetype example.exp
```

使用 `update-mime-database` 更新数据库：`(pkgs.shared-mime-info)`

```bash
update-mime-database ~/.local/share/mime
```
