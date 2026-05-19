{ ... }:
{
  programs.neovide = {
    enable = true;
    settings = {
      fork = true;
      ide = true;
      maximized = false;
      frame = "full";
      no-multigrid = false;
      srgb = false;
      tabs = true;
      theme = "auto";
      title-hidden = true;
      vsync = true;
      wsl = false;
    };
  };
}
