{ ... }:
{
  programs.plasma.powerdevil = {
    AC = {
      autoSuspend.action = "nothing";
      dimDisplay = {
        enable = true;
        idleTimeout = 300; # secs
      };
      dimKeyboard.enable = true;
      powerProfile = "performance";
      whenLaptopLidClosed = "sleep";
      whenSleepingEnter = "standby";
    };
    battery = {
      whenLaptopLidClosed = "sleep";
      whenSleepingEnter = "standbyThenHibernate";
      powerProfile = "powerSaving";
    };
    lowBattery = {
      whenLaptopLidClosed = "sleep";
      whenSleepingEnter = "standbyThenHibernate";
      powerProfile = "powerSaving";
    };
  };
}
