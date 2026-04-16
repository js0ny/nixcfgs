# Steal from https://github.com/ryan4yin/nix-config/blob/main/hardening/bwraps/wechat.nix
{
  appimageTools,
  fetchurl,
  stdenvNoCC,
}:
let
  pname = "wechat";
  sources = {
    aarch64-linux = {
      version = "4.1.0.13";
      src = fetchurl {
        url = "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_arm64.AppImage";
        hash = "sha256-YlWJxT62tXDaNwYVpsPMC5elFH8fsbI1HjTQn6ePiPo=";
      };
    };
    x86_64-linux = {
      version = "4.1.0.13";
      src = fetchurl {
        url = "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage";
        hash = "sha256-XxAvFnlljqurGPDgRr+DnuCKbdVvgXBPh02DLHY3Oz8=";
      };
    };
  };

  inherit (stdenvNoCC.hostPlatform) system;
  inherit (sources.${system} or (throw "Unsupported system: ${system}")) version src;

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/wechat/wechat
    '';
  };
in
appimageTools.wrapAppImage {
  inherit pname version;

  src = appimageContents;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${appimageContents}/wechat.desktop $out/share/applications/
    mkdir -p $out/share/pixmaps
    cp ${appimageContents}/wechat.png $out/share/pixmaps/

    substituteInPlace $out/share/applications/wechat.desktop --replace-fail AppRun wechat
  '';

  extraPreBwrapCmds = ''
    WECHAT_HOME_DIR="''${HOME}/.sandbox/.per-app/wechat"
    WECHAT_FILES_DIR="''${WECHAT_DATA_DIR}/xwechat_files"
  '';
  extraBwrapArgs = [
    "--tmpfs /home"
    "--tmpfs /root"
    "--bind \${WECHAT_HOME_DIR} \${HOME}"
    "--chdir \${HOME}"
    "--setenv QT_QPA_PLATFORM xcb"
    "--setenv QT_AUTO_SCREEN_SCALE_FACTOR 1"
    "--setenv QT_IM_MODULE fcitx"
    "--setenv GTK_IM_MODULE fcitx"
  ];
  chdirToPwd = false;
  unshareNet = false;
  unshareIpc = true;
  unsharePid = true;
  unshareUts = true;
  unshareCgroup = true;
  privateTmp = true;
}
