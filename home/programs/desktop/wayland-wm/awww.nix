{pkgs, ...}: {
  services.swww = {
    enable = true;
    # NOTE: Upstream changes the name of the package, override this to avoid warnings.
    package = pkgs.awww;
  };
}
