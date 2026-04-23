{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    attrByPath
    filterAttrs
    mapAttrsToList
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    optional
    optionals
    optionalAttrs
    types
    ;
  cfg = config.programs.dolphin;
  dolphinLib = import ../../../lib/dolphin.nix { inherit lib; };
  boolToString = value: if value then "true" else "false";

  placeBookmarkType = types.submodule (
    { ... }:
    {
      options = {
        href = mkOption {
          type = types.str;
          description = "Bookmark target URL, such as file:///path or remote:/.";
        };
        title = mkOption {
          type = types.str;
          description = "Bookmark title shown in Dolphin places.";
        };
        icon = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Optional icon name for this bookmark.";
        };
        systemItem = mkOption {
          type = types.bool;
          default = false;
          description = "Mark bookmark as system item in Dolphin places.";
        };
      };
    }
  );

  placesType = types.submodule (
    { ... }:
    {
      options = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable declarative Dolphin places (user-places.xbel).";
        };
        includeDefaults = mkOption {
          type = types.bool;
          default = true;
          description = "Include Home/Network/Trash/Recent default places.";
        };
        includePinnedHomeDirectories = mkOption {
          type = types.bool;
          default = true;
          description = "Include pinned entries from home.directories.";
        };
        extraBookmarks = mkOption {
          type = types.listOf placeBookmarkType;
          default = [ ];
          description = "Additional place bookmarks appended after defaults.";
        };
        metadata = {
          owner = mkOption {
            type = types.str;
            default = "http://www.kde.org";
            description = "Owner URL stored in places metadata.";
          };
          groupStateDevicesHidden = mkOption {
            type = types.bool;
            default = false;
            description = "Whether the Devices section is hidden in Places.";
          };
          groupStatePlacesHidden = mkOption {
            type = types.bool;
            default = false;
            description = "Whether the Places section is hidden in Places.";
          };
          groupStateRecentlySavedHidden = mkOption {
            type = types.bool;
            default = false;
            description = "Whether the Recently Saved section is hidden in Places.";
          };
          groupStateRemoteHidden = mkOption {
            type = types.bool;
            default = false;
            description = "Whether the Remote section is hidden in Places.";
          };
          groupStateRemovableDevicesHidden = mkOption {
            type = types.bool;
            default = false;
            description = "Whether the Removable Devices section is hidden in Places.";
          };
          groupStateSearchForHidden = mkOption {
            type = types.bool;
            default = false;
            description = "Whether the Search For section is hidden in Places.";
          };
          groupStateTagsHidden = mkOption {
            type = types.bool;
            default = false;
            description = "Whether the Tags section is hidden in Places.";
          };
          kdePlacesVersion = mkOption {
            type = types.str;
            default = "4";
            description = "Value for the kde_places_version metadata field.";
          };
          withBaloo = mkOption {
            type = types.bool;
            default = true;
            description = "Enable Baloo integration for Dolphin places.";
          };
          withRecentlyUsed = mkOption {
            type = types.bool;
            default = true;
            description = "Enable recently used entries in Dolphin places.";
          };
        };
      };
    }
  );

  home = config.home.homeDirectory;
  homeDirectories = attrByPath [ "home" "directories" ] { } config;

  mkPlaceBookmark =
    {
      href,
      title,
      icon ? null,
      systemItem ? false,
    }:
    {
      "+@href" = href;
      info = {
        metadata = [
          (
            {
              "+@owner" = "http://freedesktop.org";
            }
            // optionalAttrs (icon != null) {
              "bookmark:icon" = {
                "+@name" = icon;
              };
            }
          )
          (
            {
              "+@owner" = "http://www.kde.org";
            }
            // optionalAttrs systemItem {
              isSystemItem = "true";
            }
          )
        ];
      };
      inherit title;
    };

  defaultHomeBookmark = mkPlaceBookmark {
    href = "file://${home}";
    title = "Home";
    icon = "user-home";
    systemItem = true;
  };

  defaultNonHomeBookmarks = [
    (mkPlaceBookmark {
      href = "remote:/";
      title = "Network";
      icon = "folder-network";
      systemItem = true;
    })
    (mkPlaceBookmark {
      href = "trash:/";
      title = "Trash";
      icon = "user-trash";
      systemItem = true;
    })
    (mkPlaceBookmark {
      href = "recentlyused:/files";
      title = "Recent Files";
      icon = "document-open-recent";
      systemItem = true;
    })
    (mkPlaceBookmark {
      href = "recentlyused:/locations";
      title = "Recent Locations";
      icon = "folder-open-recent";
      systemItem = true;
    })
  ];

  pinnedHomeDirectoryBookmarks = mapAttrsToList (
    name: dir:
    mkPlaceBookmark {
      href = "file://${home}/${name}";
      title = name;
      icon = if dir.icon != null then dir.icon else "folder";
      systemItem = true;
    }
  ) (filterAttrs (_: dir: dir.enable && dir.pin) homeDirectories);

  extraPlaceBookmarks = map (
    bookmark:
    mkPlaceBookmark {
      href = bookmark.href;
      title = bookmark.title;
      icon = bookmark.icon;
      systemItem = bookmark.systemItem;
    }
  ) cfg.places.extraBookmarks;

  placesBookmarks =
    if cfg.places.includeDefaults then
      [ defaultHomeBookmark ]
      ++ optionals cfg.places.includePinnedHomeDirectories pinnedHomeDirectoryBookmarks
      ++ defaultNonHomeBookmarks
      ++ extraPlaceBookmarks
    else
      optionals cfg.places.includePinnedHomeDirectories pinnedHomeDirectoryBookmarks
      ++ extraPlaceBookmarks;

  placesDocument = {
    "+directive" = "DOCTYPE xbel";
    "+p_xml" = "version=\"1.0\" encoding=\"UTF-8\"";
    xbel = {
      "+@xmlns:bookmark" = "http://www.freedesktop.org/standards/desktop-bookmarks";
      "+@xmlns:kdepriv" = "http://www.kde.org/kdepriv";
      "+@xmlns:mime" = "http://www.freedesktop.org/standards/shared-mime-info";
      bookmark = placesBookmarks;
      info = {
        metadata = {
          "+@owner" = cfg.places.metadata.owner;
          GroupState-Devices-IsHidden = boolToString cfg.places.metadata.groupStateDevicesHidden;
          GroupState-Places-IsHidden = boolToString cfg.places.metadata.groupStatePlacesHidden;
          GroupState-RecentlySaved-IsHidden = boolToString cfg.places.metadata.groupStateRecentlySavedHidden;
          GroupState-Remote-IsHidden = boolToString cfg.places.metadata.groupStateRemoteHidden;
          GroupState-RemovableDevices-IsHidden = boolToString cfg.places.metadata.groupStateRemovableDevicesHidden;
          GroupState-SearchFor-IsHidden = boolToString cfg.places.metadata.groupStateSearchForHidden;
          GroupState-Tags-IsHidden = boolToString cfg.places.metadata.groupStateTagsHidden;
          kde_places_version = cfg.places.metadata.kdePlacesVersion;
          withBaloo = boolToString cfg.places.metadata.withBaloo;
          withRecentlyUsed = boolToString cfg.places.metadata.withRecentlyUsed;
        };
      };
    };
  };

  actionType = types.submodule (
    { ... }:
    {
      options = {
        name = mkOption {
          type = types.str;
          description = "Action label shown in Dolphin.";
        };
        exec = mkOption {
          type = types.str;
          description = "Command executed by this Dolphin action.";
        };
        icon = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Optional icon for this action.";
        };
        extraFields = mkOption {
          type = types.attrs;
          default = { };
          description = "Additional fields written to the [Desktop Action ...] section.";
        };
      };
    }
  );

  serviceType = types.submodule (
    { ... }:
    {
      options = {
        mimeType = mkOption {
          type = types.str;
          default = "all/allfiles";
          description = "Mime types matched by this Dolphin service.";
        };
        icon = mkOption {
          type = types.str;
          default = "system-run";
          description = "Top-level icon shown for this Dolphin service.";
        };
        desktopEntryExtra = mkOption {
          type = types.attrs;
          default = { };
          description = "Additional fields merged into the [Desktop Entry] section.";
        };
        actionOrder = mkOption {
          type = types.nullOr (types.listOf types.str);
          default = null;
          description = "Optional explicit order for the Actions= field.";
        };
        actions = mkOption {
          type = types.attrsOf actionType;
          default = { };
          description = "Actions exposed by this Dolphin service file.";
        };
      };
    }
  );
in
{
  options.programs.dolphin = {
    enable = mkEnableOption "Dolphin file manager and its service menu integration.";
    services = mkOption {
      type = types.attrsOf serviceType;
      default = { };
      description = "Declarative Dolphin service menu entries.";
    };
    places = mkOption {
      type = placesType;
      default = { };
      description = "Declarative Dolphin Places configuration.";
    };
  };

  config = mkIf cfg.enable {
    nixdots.persist.home = {
      directories = [
        ".local/share/kxmlgui5/dolphin"
      ];
      files = [
        ".config/dolphinrc"
      ];
    };
    home.packages = with pkgs.kdePackages; [
      dolphin
      dolphin-plugins # dolphin git integration
      konsole # dolphin terminal integration
    ];

    xdg.dataFile = mkMerge (
      (mapAttrsToList (
        name: serviceCfg: (dolphinLib.mkDolphinService name serviceCfg).xdg.dataFile
      ) cfg.services)
      ++ optional cfg.places.enable {
        ".nix-managed.user-places.xbel.json".text = builtins.toJSON placesDocument;
      }
    );

    home.activation = optionalAttrs cfg.places.enable {
      setupUserPlaces = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${lib.getExe pkgs.yq-go} -o xml ${config.xdg.dataHome}/.nix-managed.user-places.xbel.json > ${config.xdg.dataHome}/.nix-managed.user-places.xbel
        cp ${config.xdg.dataHome}/.nix-managed.user-places.xbel ${config.xdg.dataHome}/user-places.xbel
      '';
    };
  };
}
