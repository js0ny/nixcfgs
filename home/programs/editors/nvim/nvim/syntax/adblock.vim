" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" 1. 强制要求：以 ! 开头的注释高亮 (支持行首有空格)
syntax match adblockComment "^\s*!.*$"

" 2. 头部标签高亮 (例如 [Adblock Plus 2.0])
syntax match adblockHeader "^\[.*\]$"

" 3. 白名单/异常规则 (以 @@ 开头)
syntax match adblockException "^@@"

" 4. 各种特殊操作符 (||, ^, *)
syntax match adblockOperator "||\|\^\|\*"

" 5. 元素隐藏规则分隔符 (##, #@#, #?#)
syntax match adblockCosmeticSep "##\|#@#\|#?#"

" 6. 规则选项 (以 $ 开头，挂在规则末尾的如 $script,domain=...)
syntax match adblockOptions "\$.*$" display

" 将上述规则链接到 Vim 的标准高亮组
highlight default link adblockComment     Comment
highlight default link adblockHeader      Title
highlight default link adblockException   String
highlight default link adblockOperator    Special
highlight default link adblockCosmeticSep Operator
highlight default link adblockOptions     Type

let b:current_syntax = "adblock"
