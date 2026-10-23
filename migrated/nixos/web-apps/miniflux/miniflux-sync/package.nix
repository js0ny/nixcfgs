{
  lib,
  nodejs,
  writeShellApplication,
}:
let
  source = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./main.ts
      ./miniflux.ts
      ./package.json
    ];
  };
in
writeShellApplication {
  name = "miniflux-sync";
  text = /* bash */ ''
    exec ${lib.getExe nodejs} ${source}/main.ts
  '';
  meta = {
    description = "Synchronise Miniflux categories and feeds from declarative configuration";
    homepage = "https://github.com/js0ny/nixcfgs";
    license = lib.licenses.mit;
    mainProgram = "miniflux-sync";
  };
}
