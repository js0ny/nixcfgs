{
  pkgs,
  lib,
  ...
}:
let
  rime-wanxiang = pkgs.localPkgs.rime-wanxiang-zrm;
  rime-cantonese = pkgs.localPkgs.rime-cantonese;
  rime-dieghv = pkgs.localPkgs.rime-dieghv;
  rime-latex = pkgs.localPkgs.rime-latex;

  rimeConfigMerged = pkgs.runCommandLocal "rime-config-merged" { } ''
    mkdir -p $out

    # 引入基础配置并赋予写权限以便后续修改
    cp -r ${rime-wanxiang}/* $out/
    chmod -R u+w $out

    # 执行定制化覆盖逻辑
    rm -f $out/custom_phrase.txt

    # 合并附加词库（--no-preserve=mode 避免引入只读文件导致 rime 报错）
    cp -r --no-preserve=mode ${rime-cantonese}/* $out/
    cp -r --no-preserve=mode ${rime-dieghv}/* $out/
    cp -r --no-preserve=mode ${rime-latex}/* $out/
  '';
  rimePath = if pkgs.stdenv.isDarwin then "Library/Rime" else ".local/share/fcitx5/rime";
in
{
  home.file.${rimePath} = {
    source = rimeConfigMerged;
    recursive = true;
  };
  # yaml 最后留出一行
  home.file = {
    "${rimePath}/default.custom.yaml".source = ./default.custom.yaml;
    "${rimePath}/wanxiang_pro.custom.yaml".source = ./wanxiang_pro.custom.yaml;
    "${rimePath}/wanxiang_english.custom.yaml".source = ./wanxiang_english.custom.yaml;
    "${rimePath}/squirrel.custom.yaml".source = ./squirrel.custom.yaml;
  };
}
