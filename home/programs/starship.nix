{ ... }:
{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableIonIntegration = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      format = "$os $directory$nix_shell\n$cmd_duration$hostname$localip$shlvl$shell$env_var$jobs$sudo$username$character";
      right_format = "$singularity$kubernetes$vcsh$fossil_branch$git_branch$git_commit$git_state$git_status$hg_branch$pijul_channel$docker_context$package$c$cpp$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$fortran$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$maven$nim$nodejs$ocaml$opa$perl$php$pulumi$purescript$python$raku$rlang$red$ruby$rust$scala$solidity$swift$terraform$vlang$vagrant$xmake$zig$buf$conda$pixi$meson$spack$memory_usage$aws$gcloud$openstack$azure$crystal$custom$status$battery$time";
      battery = {
        display = [
          { threshold = 20; }
        ];
      };
      c = {
        format = "[ $symbol ($version) ]($style)";
        symbol = " ";
      };
      cmake = {
        format = "[ $symbol ($version) ]($style)";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "grey";
      };
      dart = {
        format = "[ $symbol ($version) ]($style)";
        symbol = " ";
      };
      deno = {
        format = "[ $symbol ($version) ]($style)";
        symbol = " ";
      };
      directory = {
        fish_style_pwd_dir_length = 1;
      };
      docker_context = {
        format = "[ $symbol $context ]($style)";
        symbol = " ";
      };
      dotnet = {
        detect_extensions = [
          "sln"
          "csproj"
          "fsproj"
          "xproj"
          "vbproj"
          "cs"
          "csx"
          "fs"
          "fsx"
        ];
        format = "[ $symbol ($version) ]($style)";
        symbol = " ";
      };
      elixir = {
        format = "[ $symbol ($version) ]($style)";
        symbol = " ";
      };
      elm = {
        format = "[ $symbol ($version) ]($style)";
        symbol = " ";
      };
      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };
      golang = {
        format = "[ $symbol ($version) ]($style)";
        symbol = " ";
      };
      gradle = {
        format = "[ $symbol ($version) ]($style)";
      };
      haskell = {
        format = "[ $symbol ($version) ]($style)";
        symbol = " ";
      };
      java = {
        format = "[ $symbol ($version) ]($style)";
        symbol = " ";
      };
      julia = {
        format = "[ $symbol ($version) ]($style)";
        symbol = " ";
      };
      lua = {
        format = "[ $symbol ($version) ]($style)";
        symbol = " ";
      };
      nim = {
        format = "[ $symbol ($version) ]($style)";
        symbol = "󰆥 ";
      };
      nix_shell = {
        format = "[$symbol $state]($style) ";
        heuristic = false;
        symbol = "󱄅";
      };
      nodejs = {
        format = "[ $symbol ($version) ]($style)";
        symbol = "";
      };
      os = {
        disabled = false;
        format = "[$symbol]($style)";
        style = "blue";
        symbols = {
          AlmaLinux = " ";
          Alpaquita = " ";
          Alpine = " ";
          Amazon = " ";
          Android = " ";
          Arch = " ";
          Artix = " ";
          CentOS = "  ";
          Debian = " ";
          DragonFly = " ";
          Emscripten = " ";
          EndeavourOS = " ";
          Fedora = " ";
          FreeBSD = " ";
          Garuda = "󰛓 ";
          Gentoo = " ";
          HardenedBSD = "󰞌 ";
          Illumos = "󰈸 ";
          Kali = " ";
          Linux = " ";
          Mabox = " ";
          Macos = " ";
          Manjaro = " ";
          Mariner = " ";
          MidnightBSD = " ";
          Mint = " ";
          NetBSD = " ";
          NixOS = " ";
          OpenBSD = "󰈺 ";
          OracleLinux = "󰌷 ";
          Pop = " ";
          Raspbian = " ";
          RedHatEnterprise = " ";
          Redhat = " ";
          Redox = "󰀘 ";
          RockyLinux = " ";
          SUSE = " ";
          Solus = "󰠳 ";
          Ubuntu = " ";
          Unknown = " ";
          Void = " ";
          Windows = "󰍲 ";
          openSUSE = " ";
        };
      };
      palette = "base16";
      palettes = {
        base16 = {
          base00 = "#292d3e";
          base01 = "#444267";
          base02 = "#32374d";
          base03 = "#676e95";
          base04 = "#8796b0";
          base05 = "#959dcb";
          base06 = "#959dcb";
          base07 = "#ffffff";
          base08 = "#f07178";
          base09 = "#f78c6c";
          base0A = "#ffcb6b";
          base0B = "#c3e88d";
          base0C = "#89ddff";
          base0D = "#82aaff";
          base0E = "#c792ea";
          base0F = "#ff5370";
          base10 = "#292d3e";
          base11 = "#292d3e";
          base12 = "#f07178";
          base13 = "#ffcb6b";
          base14 = "#c3e88d";
          base15 = "#89ddff";
          base16 = "#82aaff";
          base17 = "#c792ea";
          black = "#292d3e";
          blue = "#82aaff";
          bright-black = "#676e95";
          bright-blue = "#82aaff";
          bright-cyan = "#89ddff";
          bright-green = "#c3e88d";
          bright-magenta = "#c792ea";
          bright-purple = "#c792ea";
          bright-red = "#f07178";
          bright-white = "#ffffff";
          bright-yellow = "#ffcb6b";
          brown = "#ff5370";
          cyan = "#89ddff";
          green = "#c3e88d";
          magenta = "#c792ea";
          orange = "#f78c6c";
          purple = "#c792ea";
          red = "#f07178";
          white = "#959dcb";
          yellow = "#ffcb6b";
        };
      };
      rust = {
        format = "[ $symbol ($version) ]($style)";
        symbol = "";
      };
      scala = {
        format = "[ $symbol ($version) ]($style)";
        symbol = " ";
      };
      time = {
        disabled = false;
        format = "[$time]($style) ";
      };
    };
  };

}
