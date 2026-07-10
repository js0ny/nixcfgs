{
  pkgs,
  lib,
  config,
  ...
}:
let
  xdg-data = config.xdg.dataHome;
  xdg-cache = config.xdg.cacheHome;
  xdg-config = config.xdg.configHome;
  xdg-state = config.xdg.stateHome;
  user = config.home.username;
  home = config.home.homeDirectory;
in
{
  home.sessionVariables = {
    PYTHON_HISTORY = "${xdg-data}/python/history";
    GOPATH = "${xdg-data}/go";
    RUSTUP_HOME = "${xdg-data}/rustup";
    CARGO_HOME = "${xdg-data}/cargo";
    NPM_CONFIG_USERCONFIG = "${xdg-config}/npm/npmrc";
    NODE_REPL_HISTORY = "${xdg-data}/npm/node_repl_history";
    TS_NODE_HISTORY = "${xdg-data}/npm/ts_node_repl_history";
  }
  // (lib.optionalAttrs (pkgs.stdenv.isLinux) {
    MPLBACKEND = "webagg"; # matplotlib
  });
  xdg.configFile."npm/npmrc".text = ''
    prefix=${xdg-data}/npm
    cache=${xdg-cache}/npm
    init-module=${xdg-config}/npm/config/npm-init.js
    logs-dir=${xdg-state}/npm/logs
  '';
  systemd.user.tmpfiles.rules = [
    "d ${xdg-data}/npm/lib 0755 ${user} users -"
    "d ${xdg-data}/python 0755 ${user} users -"
  ];
  xdg.dataFile."cargo/config.toml".text = /* toml */ ''
    [install]
    root = "${home}/.local/bin"

    [source.ustc]
    registry = "git://mirrors.ustc.edu.cn/crates.io-index"

    [source.tuna]
    registry = "https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git"
  '';
}
