{ pkgs, ... }:
pkgs.fetchFromGitHub {
  owner = "MrOtherGuy";
  repo = "firefox-csshacks";
  rev = "a060daf10876435036508466ca5e9469c3b275d5";
  hash = "sha256-peEfQ+QNWm49M5MqO4MGpA9g/IeH03MOlAuNeMaAdHU=";
}
