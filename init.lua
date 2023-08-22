-- ------ --
-- Plugin --
-- ------ --
--> ./plugin/init.lua

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
  termencoding = 'utf-8',
  fileencoding = 'utf-8',
  fileencodings = 'utf-8,cp932',
  laststatus = 3,
  tabstop = 4,
  smartcase = true,
  clipboard = unnamedplus,
  winblend = 20,
  pumblend = 20,
}) do
  vim.opt[key] = value
end

-- ------ --
-- Keymap --
-- ------ --
vim.cmd([[
  nnoremap <expr> / '/\v'
  nnoremap <expr> ? '?\v'
]])

for key, value in pairs({
  ['x'] = '"_x', ['s'] = '"_s', ['j'] = 'gj', ['k'] = 'gk',
}) do
  vim.keymap.set('n', key, value, { silent = true, noremap = true })
end

-- Practical Vim tips#34+α --
for key, value in pairs({
  ['<C-a>'] = '<Home>',
  ['<C-e>'] = '<End>',
  ['<C-b>'] = '<Left>',
  ['<C-f>'] = '<Right>',
  ['<C-d>'] = '<Del>',
  ['<C-p>'] = '<Up>',
  ['<C-n>'] = '<Down>',
}) do
  vim.keymap.set('c', key, value, { silent = true, noremap = true })
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

vim.cmd([[
function! s:vsetsearch()
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = temp
endfunction
command! VSetSearch call s:vsetsearch()
]])

vim.g.mapleader = ' '

local opt = { silent = true, noremap = true }

-- Knocking up my vimrc.
vim.keymap.set('n', '<Leader>v', '<cmd>:edit $MYVIMRC<CR>', opt)
-- Toggle wrap
vim.keymap.set('n', '<Leader>w', '<cmd>:lua vim.wo.wrap = not vim.wo.wrap<cr>', opt)
-- Open myls
vim.keymap.set('n', '<Leader>l', require("my.ls").open, opt)
-- Fern
vim.keymap.set('n', '<Leader>o', '<cmd>Fern . -reveal=%:h -drawer -toggle<CR>', opt)
-- Telescope
vim.keymap.set('n', '<Leader>f', require("telescope.builtin").find_files, opt)
vim.keymap.set('n', '<Leader>g', require("telescope.builtin").live_grep, opt)