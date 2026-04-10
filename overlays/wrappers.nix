final: prev:
let
  lib = prev.lib;
  pkgs = final;

  getMainProgram = p: p.meta.mainProgram or p.pname;

  mkWrapperFor =
    {
      nameSuffix ? "wrapped",
      extraNativeBuildInputs ? [ ],
      makeWrapperArgs ? [ ],
      runScript ? null,
    }:
    map (
      p:
      lib.hiPrio (
        pkgs.runCommand "${p.name}-${nameSuffix}"
          {
            nativeBuildInputs = [ pkgs.makeWrapper ] ++ extraNativeBuildInputs;
            meta = p.meta;
          }
          ''
            mkdir -p "$out/bin"

            if [ -d "${p}/share" ]; then
              ln -s "${p}/share" "$out/share"
            fi

            makeWrapper ${lib.getExe p} "$out/bin/${getMainProgram p}" \
              ${lib.concatStringsSep " \\\n            " makeWrapperArgs} \
              ${lib.optionalString (runScript != null) "--run '${runScript}'"}
          ''
      )
    );

  mkFcitxIM = mkWrapperFor {
    makeWrapperArgs = [
      "--set GTK_IM_MODULE fcitx"
      "--set QT_IM_MODULE fcitx"
    ];
  };

  mkElectronWayland = mkWrapperFor {
    makeWrapperArgs = [
      "--inherit-argv0"
      ''--add-flags "\$NIX_WAYLAND_FLAGS"''
    ];
    runScript = ''
      if [ -n "$NIXOS_OZONE_WL" ] && [ -n "$WAYLAND_DISPLAY" ]; then
        NIX_WAYLAND_FLAGS="--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true"
      fi
    '';
  };

  mkLegacyJavaGUIApp = mkWrapperFor {
    extraNativeBuildInputs = [ pkgs.wmname ];
    runScript = "wmname LG3D";
  };

  # TODO: Patch desktop file. + Extra Envs
  mkFakeHomeWrapper =
    {
      pkg,
      name ? "${getMainProgram pkg}-fakehome",
      fakeHome ? ''"$HOME/.sandbox/.per-app/${getMainProgram pkg}"'',
      xdg ? true,
    }:
    pkgs.writeShellScriptBin name ''
      set -euo pipefail

      fake_home=${fakeHome}

      mkdir -p \
        "$fake_home" \
        "$fake_home/.config" \
        "$fake_home/.cache" \
        "$fake_home/.local/share" \
        "$fake_home/.local/state"

      export HOME="$fake_home"

      ${lib.optionalString xdg ''
        export XDG_CONFIG_HOME="$HOME/.config"
        export XDG_CACHE_HOME="$HOME/.cache"
        export XDG_DATA_HOME="$HOME/.local/share"
        export XDG_STATE_HOME="$HOME/.local/state"
      ''}

      exec ${lib.getExe pkg} "$@"
    '';
in
{
  inherit
    mkFcitxIM
    mkElectronWayland
    mkLegacyJavaGUIApp
    mkFakeHomeWrapper
    ;
}
