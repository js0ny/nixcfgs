final: prev: {
  ticktick = prev.ticktick.overrideAttrs (oldAttrs: {
    meta = oldAttrs.meta // {
      mainProgram = "ticktick";
    };
  });
  eslint = prev.eslint.overrideAttrs (oldAttrs: {
    meta = oldAttrs.meta // {
      mainProgram = "eslint";
    };
  });
  gocryptfs = prev.gocryptfs.overrideAttrs (oldAttrs: {
    meta = oldAttrs.meta // {
      mainProgram = "gocryptfs";
    };
  });
}
