{
  flake.nixosModules.wireguard =
    {
      pkgs,
      lib,
      secrets,
      ...
    }:
    {
      imports = [ "${secrets}/nixos/wireguard.nix" ];

      networking.wg-quick.interfaces.wg-nl =
        let
          ip = lib.getExe' pkgs.iproute2 "ip";
        in
        {
          autostart = false;
          table = "1145";
          dns = lib.mkForce [ ];
          postUp = /* bash */ ''
            ${ip} rule del fwmark 0x800/0x800 table 1145 2>/dev/null || true
            ${ip} -6 rule del fwmark 0x800/0x800 table 1145 2>/dev/null || true

            ${ip} rule add priority 1000 fwmark 0x800/0x800 table 1145
            ${ip} -6 rule add priority 1000 fwmark 0x800/0x800 table 1145
          '';

          preDown = /* bash */ ''
            ${ip} rule del fwmark 0x800/0x800 table 1145 2>/dev/null || true
            ${ip} -6 rule del fwmark 0x800/0x800 table 1145 2>/dev/null || true
          '';
        };
    };
}
