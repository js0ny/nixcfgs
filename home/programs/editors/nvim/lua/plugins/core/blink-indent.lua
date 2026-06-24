return {
  'saghen/blink.indent',
  enable = not Config.is_tty,
  event = { 'BufReadPre', 'BufNewFile' },
  --- @module 'blink.indent'
  --- @type blink.indent.Config
  opts = {},
}
