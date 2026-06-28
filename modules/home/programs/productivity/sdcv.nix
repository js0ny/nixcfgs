{
  pkgs,
  lib,
  ...
}:
let
  sdcv-fzf = pkgs.writeShellApplication {
    name = "sdcv-fzf";
    runtimeInputs = with pkgs; [
      fzf
      sdcv
      jq
    ];
    text = ''
      fzf --prompt="Dict: " \
          --phony \
          --bind "enter:reload(sdcv {q} -n --json | jq '.[].dict' -r)" \
          --preview "sdcv {q} -en --use-dict={}" \
          --preview-window=wrap \
         < <(echo)
    '';
  };
  dictionaries = {
    # Chinese <-> Chinese
    # 古汉语常用字字典 (Free to use)
    # Note: 排版较差。
    "ghycyzzd" = pkgs.fetchzip {
      url = "http://download.huzheng.org/zh_CN/stardict-ghycyzzd-2.4.2.tar.bz2";
      hash = "sha256-uH3VoTQBo1a1FBcbGZzJC3iBTdKKRr9SQ5nEjlmh47M=";
    };

    # Chinese <-> English
    # 简明英汉字典增强版 (MIT)
    "ecdict" = pkgs.misc.data.stardict.ecdict;

    # 朗道英汉字典 (GPL)
    "langdao-ec" = pkgs.fetchzip {
      url = "http://download.huzheng.org/zh_CN/stardict-langdao-ec-gb-2.4.2.tar.bz2";
      hash = "sha256-km6rCMiBaNEpOcVPKjlyhgX6R/uCpS8u4U8vL+76Zio=";
    };

    # 朗道汉英字典 (GPL)
    "langdao-ce" = pkgs.fetchzip {
      url = "http://download.huzheng.org/zh_CN/stardict-langdao-ce-gb-2.4.2.tar.bz2";
      hash = "sha256-2CNseM/oBKyJ6jlBhd5Bb6BrjreKVJt2KT75TDr4zfA=";
    };

    # Chinese <-> Latin
    # 拉汉词典 (Free to use)
    "Latin-Chinese" = pkgs.fetchzip {
      url = "http://download.huzheng.org/zh_CN/stardict-Latin-Chinese-2.4.2.tar.bz2";
      hash = "sha256-/pHHePw9h1ybDXrnmsRL8reFeEUFbLzHlnUP73SlLWc=";
    };

    # Chinese <-> Japanese
    # 小学馆-日中词典 (Free to use)
    "XiaoXueTang-jc" = pkgs.fetchzip {
      url = "http://download.huzheng.org/zh_CN/stardict-XiaoXueTang-jc-2.4.2.tar.bz2";
      hash = "sha256-KcCxO6Im9aqNkeByK8bjeDvZd/FWrKHD6tQVdzIfIo0=";
    };

  };
in
{
  home.packages = [
    pkgs.sdcv
    sdcv-fzf
  ];

  xdg.dataFile = lib.mkMerge (
    lib.mapAttrsToList (name: pkg: {
      "stardict/dic/${name}".source = pkg;
    }) dictionaries
  );
}
