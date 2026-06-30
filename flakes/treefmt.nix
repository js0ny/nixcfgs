_: {
  perSystem =
    { ... }:
    {
      treefmt.config = {
        projectRootFile = "flake.nix";
        settings.excludes = [
          "_sources/*.json"
        ];

        # keep-sorted start block=yes
        programs.keep-sorted = {
          enable = true;
          excludes = [
            "*.json"
            "*.md"
          ];
        };
        programs.nixfmt.enable = true;
        programs.prettier.enable = true;
        programs.shfmt.enable = true;
        programs.stylua = {
          enable = true;
        };
        # keep-sorted end
      };

      pre-commit = {
        check.enable = true;
        settings.hooks.treefmt.enable = true;
      };

    };
}
