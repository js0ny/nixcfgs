if exists('b:current_syntax')
  finish
endif

syntax match libmagicComment '^\s*#.*$'
syntax match libmagicDirective '^\s*!:\(mime\|ext\|apple\|strength\)\>'
syntax match libmagicOffset '^\s*>\?\s*\(0x[0-9a-fA-F]\+\|[0-9]\+\)'
syntax match libmagicType '\<\(string\|search\|regex\|lelong\|leshort\|beshort\|belong\|byte\|short\|long\|quad\|pstring\|date\|default\)\(/[0-9a-zA-Zc]*\)\?\>'
syntax match libmagicEscape '\\\(x[0-9a-fA-F]\{2}\|[0-7]\{3}\|.\)'

highlight default link libmagicComment Comment
highlight default link libmagicDirective PreProc
highlight default link libmagicOffset Number
highlight default link libmagicType Type
highlight default link libmagicEscape Special

let b:current_syntax = 'libmagic'
