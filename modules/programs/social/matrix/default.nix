{
  flake.homeModules.matrix-element =
    { pkgs, ... }:
    {
      nixdots.persist.nosnap.home = {
        directories = [
          ".config/Element"
        ];
      };
      home.packages = with pkgs; [
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
      ];

    };
}
