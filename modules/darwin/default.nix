{...}: {
  imports = [
    ./brew.nix
    ./determinate.nix
    ./tailscale.nix
    ../options
  ];
  time.timeZone = "Europe/London";
}
