{ pkgs, config, ... }:
let
  pi = "pi/agent";
  brunoSkills = pkgs.fetchFromGitHub {
    owner = "bruno-collections";
    repo = "bruno-agent-skills";
    rev = "60f8260b17fdfb3d57f1550a784ca59b6830facb";
    hash = "sha256-JiKEVgUaCjeSCbGYNMK9vVkhAPq/jdVrrBmaQ6/H090=";
  };
  gpuiSkills = pkgs.fetchgit {
    url = "https://github.com/longbridge/gpui-kit.git";
    rev = "18be16887bc2cb462f7b0a33c18bf6183344e7de";
    rootDir = "skills";
    hash = "sha256-pWINQNkuYGyZiVMVQ/IdzzBUCMprR5+YqxsoJWskL9A=";
  };
in
{
  xdg.configFile = {
    # Lazy load by default
    "${pi}/lazy-skills/herdr".source = "${config.programs.herdr.package.src}/skills/herdr";
    "${pi}/lazy-skills/tty7".source = "${pkgs.js0ny.tty7-src.src}/skills/tty7";

    # Bruno
    "${pi}/lazy-skills/bruno-collection-generator".source = "${brunoSkills}/bruno-collection-generator";
    "${pi}/lazy-skills/bruno-ci-setup".source = "${brunoSkills}/bruno-ci-setup";
    "${pi}/lazy-skills/bruno-test-writer".source = "${brunoSkills}/bruno-test-writer";

    # GPUI
    "${pi}/lazy-skills/gpui-kit".source = "${gpuiSkills}/gpui-kit";
    "${pi}/lazy-skills/gpui-kit-design-guides".source = "${gpuiSkills}/gpui-kit-design-guides";

    "${pi}/lazy-skills.json".text = builtins.toJSON [
      {
        file = "opencollection.yml";
        skill = "bruno-ci-setup";
      }
      {
        file = "opencollection.yml";
        skill = "bruno-collection-generator";
      }
      {
        file = "opencollection.yml";
        skill = "bruno-test-writer";
      }
      {
        file = "Cargo.toml";
        skill = "gpui-kit";
      }
      {
        file = "Cargo.toml";
        skill = "gpui-kit-design-guides";
      }
    ];
  };

}
