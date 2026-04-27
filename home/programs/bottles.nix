{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isx86_64 {
  home.packages = [
    (pkgs.bottles.override {
      # Intercept buildFHSEnv to modify target packages
      removeWarningPopup = true;
      buildFHSEnv =
        args:
        pkgs.buildFHSEnv (
          args
          // {
            multiPkgs =
              envPkgs:
              let
                # Fetch original package list
                originalPkgs = args.multiPkgs envPkgs;

                # Disable tests for openldap
                customLdap = envPkgs.openldap.overrideAttrs (_: {
                  doCheck = false;
                });
              in
              # Replace broken openldap with the custom one
              builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [ customLdap ];
          }
        );
    })
  ];
  dconf.settings = {
    "com/usebottles/bottles" = {
      update-date = true;
      startup-view = "page_library";
    };
  };

  xdg.dataFile."bottles/runners/${pkgs.localPkgs.dwproton.version}".source = pkgs.localPkgs.dwproton;

  nixdots.persist.home = {
    directories = [
      ".local/share/bottles"
    ];
  };
}
