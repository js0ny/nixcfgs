{
  flake.nixosModules.scroll =
    {
      config,
      inputs,
      lib,
      ...
    }:
    {
      imports = [ inputs.scroll.nixosModules.default ];
      programs.scroll = {
        enable = true;
        extraPackages = lib.mkForce [ ];
      };
      programs.uwsm = {
        enable = true;
        waylandCompositors = {
          scroll = {
            prettyName = "Scroll";
            comment = "Scroll compositor managed by UWSM";
            binPath = lib.getExe config.programs.scroll.package;
          };
        };
      };
    };
  flake.homeModules.scroll =
    {
      inputs,
      ...
    }:
    {
      imports = [ inputs.scroll.homeModules.default ];
      wayland.windowManager.scroll.enable = true;
    };
}
