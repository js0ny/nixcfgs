#!/usr/bin/env nu

# Deploy rime manually
def main [
    --clean(-X) # Delete the Rime build directory before deployment.
] {
    if $clean {
        let data_home = (
      $env.XDG_DATA_HOME?
      | default --empty ($env.HOME | path join '.local' 'share')
    )
        let build_dir = $data_home | path join 'fcitx5' 'rime' 'build'

        print $"Removing ($build_dir)"
        rm --recursive --force --permanent -- $build_dir
    }

    ^busctl --user call org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1 SetConfig sv "fcitx://config/addon/rime/deploy" s ""
    exit $env.LAST_EXIT_CODE
}
