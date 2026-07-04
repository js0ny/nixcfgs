{ ... }:
{
  perSystem =
    { config, pkgs, ... }:
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
          ];
        in
        {
          default = pkgs.mkShell {
            inputsFrom = [ config.pre-commit.devShell ];
            buildInputs = ciDeps ++ devDeps;
          };
          ci = pkgs.mkShell { buildInputs = ciDeps; };
        };
    };
}
