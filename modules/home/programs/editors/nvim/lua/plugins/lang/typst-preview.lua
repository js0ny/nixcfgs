local utils = require('core.utils')

local deps = nil

if Config.external_deps then
  deps = {
    tinymist = utils.exepath('tinymist'),
    websocat = utils.exepath('websocat'),
  }
end

return {
  'chomosuke/typst-preview.nvim',
  ft = { 'typst' },
  version = '1.*',
  opts = {
    dependencies_bin = deps,
  },
}
