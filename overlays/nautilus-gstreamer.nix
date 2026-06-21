final: prev:
let
  pkgs = prev.pkgs;
in
{
  nautilus = prev.nautilus.overrideAttrs (prevAttrs: {
    buildInputs =
      prevAttrs.buildInputs
      ++ (with pkgs.gst_all_1; [
        gst-plugins-good
        gst-plugins-bad
      ]);
  });
}
