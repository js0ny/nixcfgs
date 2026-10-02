{
  pkgs,
  lib,
  config,
  ...
}:
let
  dir = "pi/agent/extensions";
in
{
  xdg.configFile =
    let
      files = [
        "agents-override.ts"
        "command-guard.ts"
      ];
    in
    builtins.listToAttrs (
      map (f: {
        name = "${dir}/${f}";
        value.source = ./${f};
      }) files
    )
    // {

    }
    // lib.mkIf config.programs.herdr.enable {
      "${dir}/herdr-agent-state.ts".source =
        "${config.programs.herdr.package.src}/src/integration/assets/pi/herdr-agent-state.ts";
    };
}
