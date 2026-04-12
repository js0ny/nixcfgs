{ config, ... }:
{
  vdirsyncer.enable = true;
  programs.vdirsyncer = {
    enable = true;
  };
  accounts.calendar.basePath = "${config.xdg.dataHome}/calendar";
  accounts.contact.basePath = "${config.xdg.dataHome}/contacts";
  nixdots.persist.home = {
    directories = [
      ".local/share/calendar"
      ".local/share/contacts"
    ];
  };
  programs.khard = {
    enable = true;
    settings = {
      general = {
        default_action = "list";
        editor = [
          "nvim"
          "-i"
          "NONE"
        ];
      };

      "contact table" = {
        display = "formatted_name";
        preferred_phone_number_type = [
          "pref"
          "cell"
          "home"
        ];
        preferred_email_address_type = [
          "pref"
          "work"
          "home"
        ];
      };

      vcard = {
        private_objects = [
          "WeChat"
          "Telegram"
        ];
      };
    };
  };
  programs.khal = {
    enable = true;
    locale = {
      dateformat = "%F"; # ISO
    };
    settings = {
      default = {
        default_calendar = "Calendar";
        timedelta = "5d";
      };
      view = {
        agenda_event_format = "{calendar-color}{cancelled}{start-end-time-style} {title}{repeat-symbol}{reset}";
      };
    };
  };
}
