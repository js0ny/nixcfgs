{ pkgs, ... }:
let
  mkFzfAction = (import ../_mkFzfAction.nix { inherit pkgs; }).out;
in
mkFzfAction "ii-fzf" "xdg-open"
