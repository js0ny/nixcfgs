final: prev: {
  pythonPackagesExtensions = (prev.pythonPackagesExtensions or [ ]) ++ [
    (pythonFinal: pythonPrev: {
      python-telegram-bot = pythonPrev.python-telegram-bot.overrideAttrs (oldAttrs: {
        # Construct exceptions after the module-scoped PTB_TIMEDELTA fixture changes the environment.
        patches =
          (oldAttrs.patches or [ ])
          ++ prev.lib.optional (oldAttrs.version == "22.7") ./patches/python-telegram-bot-pickling-test.patch;
      });
    })
  ];
}
