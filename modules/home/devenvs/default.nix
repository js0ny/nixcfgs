{ config, ... }:
let
  xdg-data = config.xdg.dataHome;
  xdg-cache = "${config.xdg.cacheHome}";
  xdg-config = "${config.xdg.configHome}";
  xdg-state = "${config.xdg.stateHome}";
  user = "${config.home.username}";
in
{
  imports = [
    ./c.nix
    ./go.nix
    ./java.nix
    ./latex.nix
    ./lua.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
    ./typst.nix
    ./verilog.nix
    ./markdown.nix
  ];
  home.sessionVariables = {
    PYTHON_HISTORY = "${xdg-data}/python/history";
    GOPATH = "${xdg-data}/go";
    RUSTUP_HOME = "${xdg-data}/rustup";
    CARGO_HOME = "${xdg-data}/cargo";
    NPM_CONFIG_USERCONFIG = "${xdg-config}/npm/npmrc";
    NODE_REPL_HISTORY = "${xdg-data}/npm/node_repl_history";
  };
  xdg.configFile."npm/npmrc".text = ''
    prefix=${xdg-data}/npm
    cache=${xdg-cache}/npm
    init-module=${xdg-config}/npm/config/npm-init.js
    logs-dir=${xdg-state}/npm/logs
  '';
  systemd.user.tmpfiles.rules = [
    "d ${xdg-data}/npm/lib 0755 ${user} users -"
  ];
}
