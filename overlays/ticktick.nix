final: prev: {
  ticktick = prev.ticktick.overrideAttrs (oldAttrs: {
    meta = oldAttrs.meta // {
      mainProgram = "ticktick";
    };
  });
}
