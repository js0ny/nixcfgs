final: prev: {
  librepods = prev.librepods.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ final.kdePackages.kirigami ];
    # qtWrapperArgs = (oldAttrs.qtWrapperArgs or [ ]) ++ [
    #   "--set"
    #   "QT_QUICK_CONTROLS_STYLE"
    #   "Basic"
    # ];
  });
}
