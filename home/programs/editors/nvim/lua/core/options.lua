local opt = vim.opt
local g = vim.g

g.mapleader = ' '
g.maplocalleader = '\\'

-- Disable netrw,
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Disable all providers
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0
g.loaded_python3_provider = 0

g.autoformat = true

-- binary dependency: `pkgs.ripgrep`
opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
opt.grepformat = '%f:%l:%c:%m'

-- Allow nvim reading .nvim.lua under project root
opt.exrc = true

--- Visual
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.linebreak = true
opt.cmdheight = 0
opt.laststatus = 3
vim.go.laststatus = 3
opt.conceallevel = 2
opt.mousemoveevent = true

--- Editing & Scrolling
opt.confirm = true
opt.ignorecase = true
opt.smartcase = true
opt.scrolloff = 5
opt.sidescrolloff = 10

--- Identation
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.shiftround = true
opt.smartindent = false
opt.autoindent = true
