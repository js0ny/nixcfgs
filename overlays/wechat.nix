final: prev:
prev.lib.optionalAttrs (prev.stdenv.hostPlatform.system == "x86_64-linux") {
  wechat = prev.wechat.override {
    # Override before AppImage extraction so the source and version stay consistent.
    callPackage =
      path: args:
      prev.callPackage path (
        args
        // {
          version = "4.1.13";
          src = final.fetchurl {
            url = "https://web.archive.org/web/20260904115051if_/https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage";
            hash = "sha256-ay4g5wAGNy6N37rkDqhkVkUgyHsH0BYLYA7JP3j9XMI=";
          };
        }
      );
  };
}
