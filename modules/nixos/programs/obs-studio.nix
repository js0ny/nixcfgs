{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nixdots.programs.obs-studio;
in
lib.mkIf cfg.enable {
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  programs.obs-studio = {
    enable = true;
    # this will load v4l2loopback to kernel modules, but this will mess up /dev/video* devices.
    # In order to use howdy or other modules that use /dev/video* devices, (required for face recognition),
    # this option should be disabled and v4l2loopback should be loaded manually with modprobe.
    enableVirtualCamera = false;
  };
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=2 card_label="OBS Virtual Camera" exclusive_caps=1
  '';

  # Manullay load v4l2loopback with modprobe, since the automatic loading will mess up /dev/video* devices.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.policykit.exec" &&
            action.lookup("program") == "${lib.getExe' pkgs.kmod "modprobe"}" &&
            subject.isInGroup("video")) {
            return polkit.Result.YES;
        }
    });
  '';
}
