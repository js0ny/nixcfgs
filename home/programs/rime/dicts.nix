{
  pkgs,
  lib,
  ...
}: let
  rime-wanxiang = pkgs.localPkgs.rime-wanxiang-zrm;
  rime-cantonese = pkgs.localPkgs.rime-cantonese;
  rime-dieghv = pkgs.localPkgs.rime-dieghv;
  rime-latex = pkgs.localPkgs.rime-latex;

  rimeConfigMerged = pkgs.runCommandLocal "rime-config-merged" {} ''
    mkdir -p $out

    # 引入基础配置并赋予写权限以便后续修改
    cp -r ${rime-wanxiang}/* $out/
    chmod -R u+w $out

    # 执行定制化覆盖逻辑
    rm -f $out/custom_phrase.txt

    # 合并附加词库（--no-preserve=mode 避免引入只读文件导致 rime 报错）
    cp -r --no-preserve=mode ${rime-cantonese}/* $out/
    cp -r --no-preserve=mode ${rime-dieghv}/* $out/
    cp -r --no-preserve=mode ${rime-latex}/* $out/
  '';
  rimePath =
    if pkgs.stdenv.isDarwin
    then "Library/Rime"
    else ".local/share/fcitx5/rime";
in {
  home.file.${rimePath} = {
    source = rimeConfigMerged;
    recursive = true;
  };
  # yaml 最后留出一行
  home.file = {
    "${rimePath}/default.custom.yaml".source = ./default.custom.yaml;
    "${rimePath}/wanxiang_pro.custom.yaml".source = ./wanxiang_pro.custom.yaml;
    "${rimePath}/squirrel.custom.yaml".source = ./squirrel.custom.yaml;
    # 感觉用 custom_phrase.txt 更方便一些，用 user.dict.yaml 需要去 base.dict.yaml 里找字
    # 而且适合纯粹汉语拼音输入，不适合通过有独特含义的外文来输入汉字
    "${rimePath}/custom_phrase.txt" = {
      text = builtins.replaceStrings ["\\t"] ["\t"] ''
        #给自定义用户词扩展一个换行:\n, 制表符：\t, 回车符：\r, 空格：\s
        NixOS\tnixos\t1000
        国族\tgozu\t1000
        许珀尔玻瑞亚\txvpoerborvya\t1000
        许珀尔玻瑞亚\thyperborea\t1000
        苏格兰低地\tsugeljdidi\t1000
        英葡联盟\tyypulmmg\t1000
        辉格主义\thvgevuyi\t1000
        伦敦条约\tlpdptcyt\t1000
        凯皮帽\tklpimk\t1000
        凯皮帽\tkepi\t1000
        波拿巴主义\tbonabavuyi\t1000
        华沙曲\thwuaqu\t1000
        华沙曲\thwuaqv\t1000
        阿尔汉格尔斯克\taaerhjgeersike\t1000
        鲁塞尼亚\tluslniya\t1000
        鲁塞尼亚\truthenia\t1000
        喀尔巴阡\tkaerbaqm\t1000
        沃里尼亚\twoliniya\t1000
        切尔克西亚\tqxerkexiya\t1000
        阿斯特拉罕\taasitelahj\t1000
        月即别\tytjibx\t1000
        月即别汗\tytjibxhj\t1000
        月即别\tuzbek\t10
        德左\tdezo\t1000
        捷克军团\tjxkejptr\t1000
        社革党\tuegedh\t1000
        马志尼\tmavini\t1000
        马志尼\tmazzini\t1000
        法团主义\tfatrvuyi\t1000
        法西斯大议会\tfaxisidayihv\t1000
        海间联邦\thljmlmbh\t1000
        昭昭天命\tvkvktmmy\t1000
        天定命运\ttmdymyyp\t1000
        天定命运论\ttmdymyyplp\t1000
        科斯坦丁尼耶\tkesitjdyniye\t1000
        凯末尔\tataturk\t1000
        哈布斯堡-洛林\thabusibkloln\t1000
        魏玛共和国\twzmagshego\t1000
        霍亨索伦\thohgsolp\t1000
        霍亨索伦\thohenzollern\t1000
        梅塞施密特\tmzsluimite\t1000
        里希特霍芬\tlixitehoff\t1000
        安达卢西亚\tandaluxiya\t1000
        安达卢西亚\tandalucia\t1000
        张作相\tvhzoxd\t1000
        张景惠\tvhjyhv\t1000
        庐山声明\tluujugmy\t1000
        近卫文麿\tjnwzwfmo\t1000
        近卫文麿\tjnwzwfmi\t1000
        近卫文麿\tjnwzwfmaro\t1000
        大政翼赞会\tdavgyizjhv\t1000
        八纮一宇\tbahsyiyp\t1000
        昭和维新\tvkhewzxn\t1000
        关特演\tgrteyj\t1000
        关东军特别大演习\tgrdsjptebxdayjxi\t1000
        关东军特种演习\tgrteyj\t900
        零式水侦\tlyuiuvvf\t1000
        水侦\tuvvf\t1000
        舰爆\tjmbk\t1000
        九九舰爆\tjqjqjmbk\t1000
        舰攻\tjmgs\t1000
        九七舰攻\tjqqijmgs\t1000
        歼轰\tjmhs\t1000
        马来之虎\tmallvihu\t1000
        平贺让\tpyherh\t1000
        小泽治三郎\txczevisjlh\t1000
        统制派\ttsvipl\t1000
        荷兰迪亚\theljdiya\t1000
        荷兰迪亚\thollandia\t1000
        驱逐舰\tDD\t1000
        轻巡洋舰\tCL\t1000
        重巡洋舰\tCA\t1000
        战列舰\tBB\t1000
        航空母舰\tCV\t1000
        潜艇\tSS\t1000
        护卫舰\tFF\t1000
        三极管\tBJT\t1000
        场效应管\tFET\t1000
        MOS管\tMOSFET\t1000
        羊陆之交\tyhluvijc\t1000
        小丑牌\tbalatro\t1000
        山海旅探\tujhllvtj\t1000
        此事平平无奇\tciuipypywuqi\t1000
        此事平平无奇\tciui\t1000
        玉玉\tyvyv\t1000
        玉玉了\tyvyvle\t1000
        玉玉症\tyvyvvg\t1000
        温都尔汗\twfduerhj\t1000
        哈基米\thajimi\t1000
        乌角鲨\twujcua\t1000
        卡尔曼滤波\tkaermjlvbo\t1000
        结社法\tjxuefa\t1000
        胜兵必骄\tugbybijc\t1000
        败兵必哀\tblbybiai\t1000
        凉爽的夏夜\tlduddexwye\t1000
      '';
      # 词序有点问题，10 也比默认词典的高，感觉得换成 user.dict.yaml
      # 仏\tfo\t10
      # 広东\tgdds\t10
      # 広州\tgdvb\t10
      # 広西\tgdxi\t10
      # 仏山\tfouj\t10
      enable = false;
    };
    # TODO: 一个用 user.dict.yaml 格式写的词典样例，写起来太麻烦了，作者似乎也没弄转换器
    # 似乎没有用，后续研究
    "${rimePath}/user.dict.yaml" = {
      text = ''
        # vim:noexpandtab
        # rime dictionary
        # encoding: utf-8
        ---
        name: misc
        version: "LTS"
        sort: by_weight
        ...
        哈基米  hā;kh jī;tq mǐ;dd 1000
        乌角鲨  wū;pa jiǎo;dy shā;yu 1000
        温都尔汗 wēn;dw dū;ev ěr;xd hán;dg 1000

      '';
    };
  };
}
