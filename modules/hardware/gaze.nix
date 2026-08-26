{
  inputs,
  config,
  lib,
  ...
}:
let
  hw = config.nixdots.laptop.cameraIR.devicePath;
in
{
  imports = [ inputs.gaze.nixosModules.default ];
  # https://gaze.gundulabs.com/guide/nixos.html
  services.gaze = {
    enable = true;
    gui.enable = true;
    mutableConfig = false;
    # https://gaze.gundulabs.com/guide/configuration.html
    settings = {
      inference = {
        execution_provider = "cpu";
        device = "cpu";
      };
      security.level = "medium";
      cameras = {
        rgb = "primary";
        dark_luma_threshold = 20;
      }
      // (lib.mkIf (hw != "") {
        emitter_enabled = true;
        ir = hw;
      });
      auth = {
        abort_if_ssh = true;
        abort_if_lid_closed = true;
        require_confirmation_lock_screen = false;
        require_confirmation_elevation = false;
        resume_grace_ms = 0;
        start_delay_ms = 0;
        start_delay_scope = "screen_lock";
      };
      storage.encrypt_templates = lib.mkDefault false;
    };
  };
  nixdots.persist.system.directories = [
    "/var/lib/gaze"
    "/var/cache/gaze" # onnx sits here
    "/etc/gaze"
  ];
}
