{
  flake.homeModules.matrix-element =
    { pkgs, ... }:
    {
      js0ny.persist.stores.local.directories = [
        ".config/Element"
        ".cache/fractal"
        ".local/share/fractal"
      ];
      home.packages =
        with pkgs;
        [
          (element-desktop.override {
            commandLineArgs =
              if pkgs.stdenv.hostPlatform.isLinux then
                [
                  "--password-store=gnome-libsecret"
                  "--enable-features=MiddleClickAutoscroll"
                ]
              else
                "";
          })
        ]
        ++ lib.optionals (pkgs.stdenv.hostPlatform.isLinux) [ fractal ];

    };
}
