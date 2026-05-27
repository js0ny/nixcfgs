{ config, lib, ... }:
let
  cloudflareIpv4 = [
    "173.245.48.0/20"
    "103.21.244.0/22"
    "103.22.200.0/22"
    "103.31.4.0/22"
    "141.101.64.0/18"
    "108.162.192.0/18"
    "190.93.240.0/20"
    "188.114.96.0/20"
    "197.234.240.0/22"
    "198.41.128.0/17"
    "162.158.0.0/15"
    "104.16.0.0/13"
    "104.24.0.0/14"
    "172.64.0.0/13"
    "131.0.72.0/22"
  ];
  cloudflareIpv6 = [
    "2400:cb00::/32"
    "2606:4700::/32"
    "2803:f800::/32"
    "2405:b500::/32"
    "2405:8100::/32"
    "2a06:98c0::/29"
    "2c0f:f248::/32"
  ];

  realIpConfig = lib.concatMapStrings (ip: "set_real_ip_from ${ip};\n") (
    cloudflareIpv4 ++ cloudflareIpv6
  );
in
{
  sops.secrets = {
    js0nynet_cloudflare_origin_key = {
      owner = config.services.nginx.user;
      group = config.services.nginx.group;
    };
    js0nynet_ssl_cert = {
      owner = config.services.nginx.user;
      group = config.services.nginx.group;
    };
  };
  services.nginx.commonHttpConfig = ''
    ${realIpConfig}
    real_ip_header CF-Connecting-IP;
  '';
  nixdefs.consts.nginxWithCF = {
    forceSSL = true;
    enableACME = false;
    sslCertificate = config.sops.secrets.js0nynet_ssl_cert.path;
    sslCertificateKey = config.sops.secrets.js0nynet_cloudflare_origin_key.path;
  };
}
