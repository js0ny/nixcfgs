{
  lib,
  pkgs,
  ...
}:
{
  name,
  exec,
  desktopName ? name,
  xdg-terminal-exec ? pkgs.xdg-terminal-exec,
  ...
}@args:
pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  name = "${name}-terminal-app";
  dontUnpack = true;

  nativeBuildInputs = [ pkgs.copyDesktopItems ];
  desktopItems = [
    (pkgs.makeDesktopItem (
      builtins.removeAttrs args [ "xdg-terminal-exec" ]
      // {
        inherit desktopName;
        exec = "${lib.getExe xdg-terminal-exec} -e ${exec}";
        terminal = false;
      }
    ))
  ];

  installPhase = /* bash */ ''
    runHook preInstall
    mkdir -p "$out"
    runHook postInstall
  '';

  meta = {
    description = "Desktop launcher for ${desktopName} using xdg-terminal-exec";
    homepage = "https://github.com/js0ny/nixcfgs/tree/main/pkgs/terminal-app";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
})
