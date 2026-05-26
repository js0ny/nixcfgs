{ lib, config, ... }:
{
  services.tlp.enable = lib.mkForce false;
  services.power-profiles-daemon.enable = lib.mkForce false;

  services.tuned = {
    enable = !config.nixdots.linux.wsl;
    ppdSupport = true; # Analogous to power-profiles-daemon support, but for tuned
    ppdSettings = {
      profiles = {
        power-saver = "powersave-override";
        balanced = "balanced-override";
        performance = "performance-override";
      };
      battery = {
        balanced = "balanced-override";
      };
    };
    profiles = {
      powersave-override = {
        main = {
          summary = "Laptop powersave profile";
          include = "powersave";
        };
        cpu = {
          governor = "powersave";
          energy_performance_preference = "power";
          boost = 0;
        };
        audio = {
          timeout = 0;
          reset_controller = false;
        };
      };
      balanced-override = {
        main = {
          summary = "Laptop balanced profile";
          include = "balanced";
        };

        cpu = {
          governor = "powersave";
          energy_performance_preference = "balance_power";
          boost = 1;
        };
        audio = {
          timeout = 0;
          reset_controller = false;
        };
      };
      performance-override = {
        main = {
          summary = "Laptop performance profile";
          include = "throughput-performance";
        };

        cpu = {
          governor = "powersave";
          energy_performance_preference = "balance_performance";
          boost = 1;
        };
        audio = {
          timeout = 0;
          reset_controller = false;
        };
      };
    };
  };

  nixdots.persist.system = {
    directories = [
      "/etc/tuned"
    ];
  };

}
