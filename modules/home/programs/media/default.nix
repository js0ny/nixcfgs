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
  };
}
