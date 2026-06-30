{
  flake.homeModules = {
    mediatools = _: {
      imports = [
        ./packages.nix
        ./beets.nix
        ./gallery-dl.nix
      ];
    };
    elisa = import ./elisa.nix;
    lollypop = import ./lollypop.nix;
    feishin = import ./feishin.nix;
    cider-2 = import ./cider-2.nix;
    celluloid = import ./celluloid.nix;
    mpv = import ./mpv.nix;
    desktop = { inputs, ... }: {
      imports = [
        inputs.self.homeModules.mediatools
        inputs.self.homeModules.cider-2
        inputs.self.homeModules.feishin
        inputs.self.homeModules.mpv
      ];
    };
  };
}
