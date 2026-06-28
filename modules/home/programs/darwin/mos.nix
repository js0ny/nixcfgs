# alternative: https://linearmouse.app
{ pkgs, lib, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = with pkgs; [ mos ];

  targets.darwin.defaults."com.caldis.Mos" = {
    updateCheckOnAppStart = 0;
    updateIncludingBetaVersion = 0;

    hideStatusItem = 0;

    reverse = 1;
    reverseHorizontal = 1;
    reverseVertical = 1;

    smooth = 0;
    smoothHorizontal = 1;
    smoothSimTrackpad = 0;
    smoothVertical = 1;
  };

}
