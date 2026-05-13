fmt:
    nix fmt

update:
    nix run github:berberman/nvfetcher
    nix flake update

repl:
    nix repl --expr 'import <nixpkgs> {}'
