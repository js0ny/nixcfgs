local M = {}

M.is_tty = os.getenv('TERM') == 'linux' and vim.fn.has('gui_running') == 0
M.colemak = false
M.enable_all_lsps = false
M.external_deps = true
M.enable_llm_completion = true

local user = os.getenv('USER')
M.wsl_username = user
M.wsl_bindir = user and ('/mnt/c/Users/' .. user .. '/scoop/shims') or nil

return M
