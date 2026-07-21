{
  config,
  lib,
  pkgs,
  ...
}:
let
  matrixDomain = config.nixdefs.endpoints.matrix.domain;
  pickerPath = "/stickerpicker";
  stateDir = "/var/lib/matrix-stickers";
  packsDir = "${stateDir}/packs";
  user = config.nixdots.user.name;
  source = pkgs.applyPatches {
    name = "maunium-stickerpicker-source";
    src = pkgs.fetchFromGitHub {
      owner = "maunium";
      repo = "stickerpicker";
      rev = "c4ac072dd33ae5c89144d0222103786c8d8c1ba4";
      hash = "sha256-BElO5tD2KrcGdV5wjdEAtkRlkF8A5XYPUGqojRXPTyg=";
    };
    patches = [ ./stickerpicker-telegram-cache.patch ];
  };
  python = pkgs.python312.withPackages (
    ps: with ps; [
      aiohttp
      cryptg
      pillow
      python-magic
      (telethon.overridePythonAttrs (_: {
        # Python 3.12 removed implicit event-loop creation, but only an upstream sync-helper test relies on it.
        doCheck = false;
      }))
      yarl
    ]
  );
  manager = pkgs.writeText "matrix-stickers.py" (builtins.readFile ./matrix-stickers.py);
  cli = pkgs.writeShellApplication {
    name = "matrix-stickers";
    text = /* bash */ ''
      export PYTHONPATH=${source}
      export STICKERPICKER_SOURCE=${source}
      export MATRIX_STICKER_PICKER_URL="https://${matrixDomain}${pickerPath}/?theme=\$theme"
      exec ${lib.getExe python} ${manager} "$@"
    '';
  };
in
{
  environment.systemPackages = [ cli ];

  nixdots.persist.system.directories = [
    {
      directory = stateDir;
      inherit user;
      group = "users";
      mode = "0755";
    }
  ];

  systemd.tmpfiles.rules = [
    "d ${stateDir}/private 0700 ${user} users -"
    "d ${packsDir} 0755 ${user} users -"
    ''f ${packsDir}/index.json 0644 ${user} users - {"packs":[]}''
  ];

  services.nginx.virtualHosts.${matrixDomain}.locations = {
    "^~ ${pickerPath}/packs/" = {
      alias = "${packsDir}/";
      extraConfig = /* nginx */ ''
        add_header Cache-Control "no-store" always;
      '';
    };
    "^~ ${pickerPath}/" = {
      alias = "${source}/web/";
      extraConfig = /* nginx */ ''
        index index.html;
      '';
    };
  };

  # [Human Intervention] Run `matrix-stickers enable` once for each Element account that should use this picker.
}
