{pkgs, ...}: let
  mkFzfAction = (import ../_mkFzfAction.nix {inherit pkgs;}).out;
in
  mkFzfAction "edit-fzf" ''"''${EDITOR:-vim}"''
