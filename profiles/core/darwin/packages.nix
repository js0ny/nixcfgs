{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    iproute2mac
    # use gnu-compatible coreutils
    uutils-coreutils-noprefix
    uutils-findutils
    gnused
    gawk
    gnutar
    gzip
    getopt
    git
    mas
  ];
  js0ny.homebrew.formulae = [ "dark-mode" ];
}
