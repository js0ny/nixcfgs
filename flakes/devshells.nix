{
  inputs,
  ...
}:
{
  perSystem =
    {
      config,
      lib,
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
            nufmt
            lua
            keep-sorted
            llvmPackages.clang-tools
            cli11
            taglib
            # taglib.pc hardcodes `-lz`, but nixpkgs' taglib does not propagate zlib
            zlib
            pkg-config
          ];
          devDeps = with pkgs; [
            # keep-sorted start
            ast-grep
            bash-language-server
            disko
            gh
            inputs.nix-tree-rs.packages.${pkgs.stdenv.hostPlatform.system}.default
            lua-language-server
            nil
            nixd
            nixos-anywhere
            nushell
            pyright
            taplo
            vtsls
            # keep-sorted end
          ];
        in
        {
          default = pkgs.mkShell {
            inputsFrom = [ config.pre-commit.devShell ];
            buildInputs = ciDeps ++ devDeps;
            shellHook = config.pre-commit.shellHook + /* bash */ ''
              if repo_root="$(${lib.getExe pkgs.git} rev-parse --show-toplevel 2>/dev/null)"; then
                export PATH="$repo_root/.bin:$PATH"
              fi
              unset repo_root
            '';
          };
          ci = pkgs.mkShell { buildInputs = ciDeps; };
        };
    };
}
