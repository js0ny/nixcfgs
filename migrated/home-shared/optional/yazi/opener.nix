{
  # https://yazi-rs.github.io/docs/configuration/yazi/
  programs.yazi.settings = {
    opener = {
      open = [
        {
          run = "xdg-open %s1";
          desc = "Open with default app";
          for = "linux";
        }
        {
          run = "open %s";
          desc = "Open with default app";
          for = "macos";
        }
        {
          run = ''start "" %s1'';
          desc = "Open with default app";
          for = "windows";
          orphan = true;
        }
        {
          run = "termux-open %s1";
          desc = "Open with default app";
          for = "android";
        }
      ];
      reveal = [
        {
          run = "xdg-open %d1";
          desc = "Reveal";
          for = "linux";
        }
        {
          run = "open -R %s1";
          desc = "Reveal";
          for = "macos";
        }
        {
          run = "explorer /select,%s1";
          desc = "Reveal";
          for = "windows";
          # Detach from Yazi's task management so Explorer can outlive Yazi.
          orphan = true;
        }
        {
          run = "termux-open %d1";
          desc = "Reveal";
          for = "android";
        }
      ];
    };
  };
}
