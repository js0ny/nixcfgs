{
  flake.nixosModules.rime = _: {
    imports = [ ./fcitx.nix ];
  };
  flake.homeModules.rime = { pkgs, lib, ... }: {
    imports = [
      ./dicts.nix
      ./squirrel.nix
    ];
    js0ny.persist.stores.state.directories = [ ".local/share/fcitx5" ];
    stylix.targets.fcitx5.enable = false;
    home.activation.deployRime =
      if pkgs.stdenv.hostPlatform.isDarwin then
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
