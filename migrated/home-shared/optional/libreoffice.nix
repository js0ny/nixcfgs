{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.libreoffice ];

  programs.dolphin.services.office2pdf = {
    mimeType = lib.concatStringsSep ";" [
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    ];
    icon = "application-pdf";
    desktopEntryExtra = {
      "X-KDE-Priority" = "TopLevel";
      "X-KDE-StartupNotify" = false;
    };
    actions = {
      "convertToPDF" = {
        name = "Convert to PDF";
        exec = ''${lib.getExe' pkgs.libreoffice "soffice"} --headless --convert-to pdf "%f" --outdir .'';
        extraFields = {
          "Name[CN]" = "转换为 PDF";
        };
      };
    };
  };

}
