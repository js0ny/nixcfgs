{
  pkgs,
  # lib,
  ...
}: {
  programs.sdcv = {
    enable = true;

    dictionaries = {
      "langdao-ec" = pkgs.fetchzip {
        url = "http://download.huzheng.org/zh_CN/stardict-langdao-ec-gb-2.4.2.tar.bz2";
        hash = "sha256-km6rCMiBaNEpOcVPKjlyhgX6R/uCpS8u4U8vL+76Zio=";
      };

      "langdao-ce" = pkgs.fetchzip {
        url = "http://download.huzheng.org/zh_CN/stardict-langdao-ce-gb-2.4.2.tar.bz2";
        hash = "sha256-2CNseM/oBKyJ6jlBhd5Bb6BrjreKVJt2KT75TDr4zfA=";
      };

      "ecdict" = pkgs.localPkgs.stardictDictionary.ECDICT;
      # "my-complex-dict" = pkgs.my-custom-dict;

      # "test-dict" = ./local-dict-folder;
    };
  };
}
