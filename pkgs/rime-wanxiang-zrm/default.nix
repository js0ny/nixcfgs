{pkgs, ...}: let
  version = "v13.3.12";
in
  pkgs.fetchzip {
    url = "https://github.com/amzxyz/rime_wanxiang/releases/download/${version}/rime-wanxiang-zrm-fuzhu.zip";
    sha256 = "sha256-vnhg+//ByZmQ2uxBZTn3cDYKrUFckLAuU8MfB8kSDVA=";
    stripRoot = false;
  }
