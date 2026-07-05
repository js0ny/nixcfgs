{
  imports = [
    ./duti.nix
    ./mime.nix
  ];
  flake.nixosModules.core = _: {
    xdg.mime.enable = true;
  };
  flake.homeModules.core =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      apps = config.nixdots.apps;
      magicDir = ./magic;

      customMagicCompiled = pkgs.runCommand "custom.magic.mgc" { } ''
        cat ${magicDir}/*.magic > custom.magic

        ${lib.getExe pkgs.file} -C -m custom.magic

        mv custom.magic.mgc $out
      '';
    in
    {
      home.sessionVariables = {
        EDITOR = apps.editor.tui.exe;
        VISUAL = apps.editor.tui.exe;
        BROWSER = apps.browser.exe;
      };
    };
}
