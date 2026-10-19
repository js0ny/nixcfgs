{ pkgs, ... }:
let
  mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
in
{
  home.packages = [
    # Don't build on Darwin
    (pkgs.ouch.override { enableUnfree = pkgs.stdenv.hostPlatform.isLinux; })
  ];

  # Yazi Integration
  programs.yazi = {
    plugins = { inherit (pkgs.yaziPlugins) ouch; };
    # yazi-rs.github.io/docs/configuration/yazi/
    settings = {
      plugin.prepend_previewers = [
        {
          inherit mime;
          run = /* bash */ "ouch --show-file-icons";
        }
      ];
      opener = {
        extract = [
          {
            run = /* bash */ "ouch decompress --yes -- %s";
            desc = "Extract with ouch";
          }
        ];
      };
      open.prepend_rules = [
        {
          inherit mime;
          use = [
            "extract"
            "open"
            "reveal"
          ];
        }
        # {
        #   mime = "*";
        #   use = lib.mkAfter [ "compress" ];
        # }
      ];
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = [
            "C"
            "c"
          ];
          run = "plugin ouch zip";
          desc = "Compress with ouch (zip)";
        }
        {
          on = [
            "C"
            "z"
          ];
          run = "plugin ouch tar.zst";
          desc = "Compress with ouch (tar.zst)";
        }
        {
          on = [
            "C"
            "7"
          ];
          run = "plugin ouch 7z";
          desc = "Compress with ouch (7z)";
        }
      ];
    };
  };
}
