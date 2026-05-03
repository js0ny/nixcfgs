{
  config,
  inputs,
  pkgs,
  ...
}:
let
  system = pkgs.stdenv.system;
  ccpkg = inputs.llm-agents.packages.${system}.claude-code;
in
{
  nixdots.persist.home = {
    directories = [
      ".config/claude"
    ];
  };
  home.sessionVariables = {
    CLAUDE_CONFIG_DIR = "${config.xdg.configHome}/claude";
    # 用第三方模型遇到缓存命中率太低的问题一般需要把 cc 默认附加的 attribution header 禁用掉
    # source: zhihu
    CLAUDE_CODE_ATTRIBUTION_HEADER = "0";
  };
  programs.claude-code = {
    enable = true;
    package = ccpkg;
  };
}
