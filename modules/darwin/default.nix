{...}: {
  imports = [
    ./brew.nix
    ./determinate.nix
    ./tailscale.nix
  ];
  time.timeZone = "Europe/London";
}
