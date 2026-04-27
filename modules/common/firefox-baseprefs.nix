# This setup is imported to programs.firfox.preferences in NixOS,
# and non-NixOS home-manager
{
  "screenshots.browser.component.enabled" = false;
  "toolkit.telemetry.enabled" = false;
  "toolkit.telemetry.archive.enabled" = false;
  "browser.shell.checkDefaultBrowser" = false;
  "browser.contentblocking.category" = "strict";
  "browser.formfill.enable" = false;
  "extensions.formautofill.creditCards.enabled" = false;
  "dom.forms.autocomplete.formautofill" = false;
  "browser.urlbar.update2.engineAliasRefresh" = true;
  "browser.newtabpage.activity-stream.showSponsored" = false;
  "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
  "toolkit.tabbox.switchByScrolling" = true;
  "widget.use-xdg-desktop-portal.file-picker" = 1;
  "widget.use-xdg-desktop-portal.mime-handler" = 1;
}
