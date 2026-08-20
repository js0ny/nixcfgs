{
  inputs,
  ...
}:
{
  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      devShells =
        let
          ciDeps = with pkgs; [
            stylua
            prettier
            ruff
            shfmt
            shellcheck
            nixfmt
            nvfetcher
            nufmt
            lua
            keep-sorted
          ];
          devDeps = with pkgs; [
            lua-language-server
            pkgs.typescript-language-server
            pkgs.bash-language-server
            pyright
            taplo
            nixd
            nil
            nushell
            inputs.nix-tree-rs.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
        in
        {
          default = pkgs.mkShell {
            inputsFrom = [ config.pre-commit.devShell ];
            buildInputs = ciDeps ++ devDeps;
            shellHook = config.pre-commit.shellHook;
          };
          ci = pkgs.mkShell { buildInputs = ciDeps; };
        };
    };
}
