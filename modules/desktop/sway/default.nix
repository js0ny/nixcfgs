{
  flake.nixosModules.sway = { lib, ... }: {
    programs.sway = {
      enable = true;
      xwayland.enable = true;
      extraOptions = [ "--unsupported-gpu" ];
      extraPackages = lib.mkForce [ ];
    };
  };
}
