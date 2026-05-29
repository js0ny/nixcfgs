{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks.flakeModule
  ];
  perSystem =
    { ... }:
    {
      treefmt.config = {
        projectRootFile = "flake.nix";
        settings.excludes = [
          "_sources/*.json"
        ];
        programs.keep-sorted = {
          enable = true;
          excludes = [
            "*.json"
            "*.md"
          ];
        };

        # keep-sorted start
        programs.nixfmt.enable = true;
        programs.prettier.enable = true;
        programs.shfmt.enable = true;
        programs.stylua.enable = true;
        # keep-sorted end
      };

      pre-commit = {
        check.enable = true;
        settings.hooks.treefmt.enable = true;
      };

    };
}
