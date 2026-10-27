{ pkgs, config, ... }:
let
  pi = "pi/agent";
in
{
  xdg.configFile = {
    # Lazy load by default
    "${pi}/lazy-skills/herdr".source = "${config.programs.herdr.package.src}/skills/herdr";
    "${pi}/lazy-skills/tty7".source = "${pkgs.js0ny.tty7-src.src}/skills/tty7";
  };
}
