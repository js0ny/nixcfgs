{ config, ... }:
let
  xdg-data = config.xdg.dataHome;
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
  ];
  home.sessionVariables = {
    PYTHON_HISTORY = "${xdg-data}/python/history";
    GOPATH = "${xdg-data}/go";
    RUSTUP_HOME = "${xdg-data}/rustup";
    CARGO_HOME = "${xdg-data}/cargo";
  };
}
