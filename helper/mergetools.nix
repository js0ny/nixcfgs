{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.mergetools;

  homeDir = config.home.homeDirectory;

  # 剥离前缀，用于 home.file 相对路径计算
  stripHomePrefix =
    target:
    let
      prefix = homeDir + "/";
    in
    if hasPrefix prefix target then
      removePrefix prefix target
    else
      abort "mergetools: target '${target}' must start with '${prefix}'";

  # 任务数据结构
  mergeTargetType = types.submodule (
    { name, ... }:
    {
      options = {
        enable = mkEnableOption "this merge task" // {
          default = true;
        };
        target = mkOption { type = types.str; };
        settings = mkOption {
          type = types.attrs;
          default = { };
        };
        format = mkOption {
          type = types.enum [
            "yaml"
            "json"
            "ini"
          ];
        };
        force = mkOption {
          type = types.bool;
          default = false;
        };
        generateReference = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to generate a .nix-managed reference file next to the target.";
        };
      };
    }
  );

  activeTasks = filterAttrs (n: v: v.enable) cfg;

  # 根据格式生成内容
  getContent =
    task:
    if task.format == "json" then
      builtins.toJSON task.settings
    else if task.format == "yaml" then
      generators.toYAML { } task.settings
    else
      generators.toINI { } task.settings;

  # 仅在目标文件已存在时使用的合并命令
  getMergeCmdStr =
    task: patchPath:
    if task.format == "json" then
      ''${pkgs.yq-go}/bin/yq -i -o json -P --indent 2 ". *= load(\"${patchPath}\")" "$TARGET"''
    else if task.format == "yaml" then
      ''${pkgs.yq-go}/bin/yq -i -oy -P ". *= load(\"${patchPath}\")" "$TARGET"''
    else
      ''${pkgs.crudini}/bin/crudini --merge "$TARGET" < "${patchPath}"'';
in
{
  options.mergetools = mkOption {
    type = types.attrsOf mergeTargetType;
    default = { };
    description = "Declarative config merging (Home Manager Only)";
  };

  config = mkIf (activeTasks != { }) {
    # 1. 生成参考文件 (home.file)
    home.file =
      let
        tasksWithRef = filterAttrs (n: v: v.generateReference) activeTasks;
      in
      mapAttrs' (
        name: task:
        let
          relTarget = stripHomePrefix task.target;
          dir = dirOf relTarget;
          base = baseNameOf relTarget;
          refPath = if dir == "." then ".${base}.nix-managed" else "${dir}/.${base}.nix-managed";
        in
        nameValuePair refPath {
          text = getContent task;
        }
      ) tasksWithRef;

    # 2. 注入激活脚本 (home.activation)
    home.activation = mapAttrs (
      name: task:
      let
        relTarget = stripHomePrefix task.target;
        dir = dirOf relTarget;
        base = baseNameOf relTarget;
        patchPath =
          if task.generateReference then
            if dir == "." then "$HOME/.${base}.nix-managed" else "$HOME/${dir}/.${base}.nix-managed"
          else
            "${pkgs.writeText "${name}-patch.${task.format}" (getContent task)}";
      in
      hm.dag.entryAfter [ "writeBoundary" ] ''
        TARGET="${task.target}"
        PATCH="${patchPath}"
        FORCE="${if task.force then "true" else "false"}"

        if [ -f "$TARGET" ] || [ "$FORCE" = "true" ]; then
          if [ -f "$PATCH" ]; then
            mkdir -p "$(dirname "$TARGET")"

            if [ ! -f "$TARGET" ]; then
              echo "mergetools: Initializing missing config from patch: $TARGET"
              cp "$PATCH" "$TARGET"
              chmod u+rw "$TARGET"
            else
              echo "mergetools: Merging Nix managed config into: $TARGET"
              ${getMergeCmdStr task "$PATCH"}
            fi
          fi
        else
          echo "mergetools: Skipping merge for $TARGET (file missing & force=false)"
        fi
      ''
    ) activeTasks;
  };
}
