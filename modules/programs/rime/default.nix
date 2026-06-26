{
  flake.nixosModules.rime = { pkgs, ... }: {
    i18n.inputMethod = {
      enable = true;
      enableGtk2 = true;
      enableGtk3 = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        # plasma6Support = true;
        addons = with pkgs; [
          fcitx5-rime
          kdePackages.fcitx5-configtool
          kdePackages.fcitx5-qt
          fcitx5-gtk
          fcitx5-lua
        ];
      };
    };
  };
  flake.homeModules.rime = { pkgs, lib, ... }: {
    imports = [
      ./dicts.nix
      ./fcitx.nix
      ./squirrel.nix
    ];
    home.activation.deployRime =
      if pkgs.stdenv.isDarwin then
        lib.hm.dag.entryAfter [ "writeBoundary" ] /* bash */ ''
          /Library/Input\ Methods/Squirrel.app/Contents/MacOS/Squirrel --reload
        ''
      else
        # TODO: Buggy
        lib.hm.dag.entryAfter [ "writeBoundary" ] /* bash */ ''
          # ${lib.getExe' pkgs.kdePackages.qttools "qdbus"} org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1.SetConfig "fcitx://config/addon/rime/deploy" ""
        '';
  };
}
