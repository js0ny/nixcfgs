{
  inputs,
  config,
  ...
}:
let
  dots = config.nixdots.core.dots;
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  programs.okular = {
    enable = true;
    accessibility = {
      changeColors.mode = "InvertLightness";
      highlightLinks = true;
    };
    general = {
      mouseMode = "TextSelect";
      obeyDrm = true;
      openFileInTabs = true;
      showScrollbars = true;
      viewContinuous = true;
      viewMode = "Single";
      zoomMode = "autoFit";
    };
    performance = {
      enableTransparencyEffects = true;
      memoryUsage = "Aggressive";
    };
  };
  mergetools.okularpartrc = {
    target = "${config.xdg.configHome}/okularpartrc";
    format = "ini";
    settings = {
      "Core General" = {
        ExternalEditor = "Custom";
        ExternalEditorCommand = "nvim +%l|%c";
      };
    };
  };
  mergetools.okular-poppler = {
    target = "${config.xdg.configHome}/okular-generator-popplerrc";
    format = "ini";
    settings = {
      Signatures = {
        DBCertificatePath = "file://${config.xdg.dataHome}/pki/nssdb/";
        SignatureBackend = "NSS";
        UseDefaultCertDB = false;
      };
    };
  };
  xdg.dataFile."kxmlgui5/okular".source =
    mkSymlink "${dots}/modules/home/programs/productivity/okular";
}
