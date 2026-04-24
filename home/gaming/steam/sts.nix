{ ... }:
let
in
{
  xdg.dataFile."Steam/steamapps/common/SlayTheSpire/jre/lib/management/".text = ''
    com.oracle.usagetracker.track.last.usage=false
  '';
}
