# xremap/spcl.nix - Space Layer
_:
let
  dest = "F24";
in
{
  services.xremap.config = {
    virtual_modifiers = [ dest ];
    modmap = [
      {
        name = "SpaceLayer - Virtual Modifier";
        remap = {
          "Space" = {
            held = dest;
            alone = "Space";
          };
        };
      }
    ];
    keymap = [
      {
        name = "SpaceLayer";
        remap = {
          F24-h = "Left";
          F24-j = "Down";
          F24-k = "Up";
          F24-l = "Right";
        };
      }
    ];
  };
}
