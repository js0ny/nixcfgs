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
          commandLineArgs = if pkgs.stdenv.isLinux then "--password-store=gnome-libsecret" else "";
        })
      ];
    };
}
