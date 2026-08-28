{
  flake.nixosModules.clash-verge = { pkgs, ... }: {
    programs.clash-verge = {
      enable = true;
      tunMode = true;
      serviceMode = true;
    };
    home-manager.sharedModules = [
      {
        nixdots.persist.nosnap.home.directories = [
          ".local/share/io.github.clash-verge-rev.clash-verge-rev"
        ];

        xdg.dataFile."io.github.clash-verge-rev.clash-verge-rev/profiles/Merge.yaml".text = /* yaml */ ''
          # Profile Enhancement Merge Template for Clash Verge

          profile:
            store-selected: true

          prepend-rules:
            - IP-CIDR,100.64.0.0/10,DIRECT,no-resolve
            - IP-CIDR6,fd7a:115c:a1e0::/48,DIRECT,no-resolve
            - DOMAIN-SUFFIX,ts.net,DIRECT

          prepend-rule-providers: {}

          prepend-proxies: []
          prepend-proxy-providers: {}
          prepend-proxy-groups: []

          append-rules: []
          append-rule-providers: {}
          append-proxies: []
          append-proxy-providers: {}
          append-proxy-groups: []

          tun:
            route-exclude-address:
              - 100.64.0.0/10
              - fd7a:115c:a1e0::/48

          dns:
            fake-ip-filter:
              - "*.ts.net"

        '';
      }
    ];
  };
}
