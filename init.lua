-- ------------------------------------- --
-- Plugin(autoload. press 'gF' to jump.) --
-- ------------------------------------- --
-- The result is that all directories in 'runtimepath' will be searched for the "plugin" sub-directory and all files ending in ".vim" or ".lua" will be sourced (in alphabetical order per directory),
-- also in subdirectories. First "*.vim" are sourced, then "*.lua" files, per directory. (See also :help load-plugins.)
--> ./plugin/init.lua

--> ./lua/my/dirtab/init.lua
require("my.dirtab").setup()

-- ------- --
-- Setting --
-- ------- --
for key, value in pairs({
  termguicolors = true,
  number = true,
  wrap = false,
  expandtab = true,
  cursorline = true,
  cursorcolumn = true,
  list = true,
  listchars = {tab='»-', trail='-', extends='»', precedes='«', nbsp='%', eol='↲'},
  fileencoding = 'utf-8',
  fileencodings = 'utf-8,cp932',
  laststatus = 3,
  tabstop = 4,
  smartcase = true,
  winblend = 20,
  pumblend = 20,
}) do
  vim.opt[key] = value
end

vim.opt.clipboard:append{'unnamedplus'}

-- ------ --
-- Keymap --
-- ------ --
vim.keymap.set('n', '/', '/\\v', { silent = false, noremap = true })
vim.keymap.set('n', '?', '?\\v', { silent = false, noremap = true })

for key, value in pairs({
  ['x'] = '"_x', ['s'] = '"_s', ['j'] = 'gj', ['k'] = 'gk',
}) do
  vim.keymap.set('n', key, value, { silent = true, noremap = true })
end

-- Practical Vim tips#34+α --
for key, value in pairs({
  ['<C-a>'] = '<Home>', ['<C-e>'] = '<End>', ['<C-b>'] = '<Left>', ['<C-f>'] = '<Right>',
  ['<C-d>'] = '<Del>', ['<C-p>'] = '<Up>', ['<C-n>'] = '<Down>',
}) do
  vim.keymap.set('c', key, value, { silent = false, noremap = true })
end

-- Practical Vim tips#36+α --
for key, value in pairs({
  ['[b'] = ':bprevious<CR>', [']b'] = ':bnext<CR>', ['[B'] = ':bfirst<CR>', [']B'] = ':blast<CR>',
  ['[c'] = ':cprevious<CR>', [']c'] = ':cnext<CR>', ['[C'] = ':cfirst<CR>', [']C'] = ':clast<CR>',
  ['[l'] = ':lprevious<CR>', [']l'] = ':lnext<CR>', ['[L'] = ':lfirst<CR>', [']L'] = ':llast<CR>',
  ['[t'] = ':tabprevious<CR>', [']t'] = ':tabnext<CR>', ['[T'] = ':tabfirst<CR>', [']T'] = ':tablast<CR>',
  ['[q'] = ':colder<CR>', [']q'] = ':cnewer<CR>',
}) do
  vim.keymap.set('n', key, value, { silent = true, noremap = true })
end

-- Practical Vim tips#86 --
vim.keymap.set('x', '*', ':<C-u>VSetSearch<CR>/<C-R>=@/<CR><CR>', { silent = true, noremap = true })
vim.keymap.set('x', '#', ':<C-u>VSetSearch<CR>?<C-R>=@/<CR><CR>', { silent = true, noremap = true })

-- 挿入モードから抜ける(jjで始まる入力はしないのでESCにBind)
vim.keymap.set('i', 'jj', '<Esc>', { silent = true, noremap = true })

vim.cmd([[
function! s:vsetsearch()
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = temp
endfunction
command! VSetSearch call s:vsetsearch()
]])

-- Terminal --
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { silent = true, noremap = true })

-- Alt --
-- !!! Get used to the defaults !!! --
-- vim.keymap.set('n', '<M-j>', '<C-w>j', { silent = true, noremap = true }) --
-- vim.keymap.set('n', '<M-k>', '<C-w>k', { silent = true, noremap = true }) --
-- vim.keymap.set('n', '<M-h>', '<C-w>h', { silent = true, noremap = true }) --
-- vim.keymap.set('n', '<M-l>', '<C-w>l', { silent = true, noremap = true }) --
-- vim.keymap.set('n', '<M-J>', '<C-e>', { silent = true, noremap = true }) --
-- vim.keymap.set('n', '<M-K>', '<C-y>', { silent = true, noremap = true }) --
-- vim.keymap.set('n', '<M-H>', 'zh', { silent = true, noremap = true }) --
-- vim.keymap.set('n', '<M-L>', 'zl', { silent = true, noremap = true }) --
-- vim.keymap.set('n', '<M-q>', '<cmd>:q<cr>', { silent = true, noremap = true }) --

-- Leader --
vim.g.mapleader = ' '

-- Knocking up my vimrc.
vim.keymap.set('n', '<Leader>v', '<CMD>:edit $MYVIMRC<CR>', { silent = true, noremap = true })
-- Entering terminal mode and insert mode.
vim.keymap.set('n', '<Leader>t', '<CMD>terminal<CR><CMD>startinsert<CR>', { silent = true, noremap = true })
-- Toggle wrap
vim.keymap.set('n', '<Leader>w', '<CMD>:lua vim.wo.wrap = not vim.wo.wrap<CR>', { silent = true, noremap = true })
