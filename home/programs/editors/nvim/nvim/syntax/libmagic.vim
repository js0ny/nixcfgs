if exists("b:current_syntax")
        finish
      endif

      " 匹配注释 (以 # 开头)
      syntax match libmagicComment "^\s*#.*$"

      " 匹配元指令 (如 !:mime, !:ext)
      syntax match libmagicDirective "^\s*!:\(mime\|ext\|apple\|strength\)\>"

      " 匹配偏移量 (支持层级嵌套 > 和十六进制)
      syntax match libmagicOffset "^\s*>\?\s*\(0x[0-9a-fA-F]\+\|[0-9]\+\)"

      " 匹配数据类型及其修饰符 (如 search/256, regex/100, lelong)
      syntax match libmagicType "\<\(string\|search\|regex\|lelong\|leshort\|beshort\|belong\|byte\|short\|long\|quad\|pstring\|date\|default\)\(/[0-9a-zA-Zc]*\)\?\>"

      " 匹配转义字符和特征码 (如 \x00, \n)
      syntax match libmagicEscape "\\\(x[0-9a-fA-F]\{2}\|[0-7]\{3}\|.\)"

      " 链接到当前主题的标准高亮组
      highlight default link libmagicComment Comment
      highlight default link libmagicDirective PreProc
      highlight default link libmagicOffset Number
      highlight default link libmagicType Type
      highlight default link libmagicEscape Special

      let b:current_syntax = "libmagic"
