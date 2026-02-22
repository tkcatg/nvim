-- ======================================================== --
-- BOOTSTRAP LAZY.NVIM (https://github.com/folke/lazy.nvim) --
-- ======================================================== --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { ------------------
    "hrsh7th/vim-eft",
    ------------------
    config = function()
      for key, value in pairs({
        ['f'] = '<Plug>(eft-f)', ['F'] = '<Plug>(eft-F)', ['t'] = '<Plug>(eft-t)', ['T'] = '<Plug>(eft-T)', [';'] = '<Plug>(eft-repeat)', 
      }) do
        vim.keymap.set('n', key, value, { silent = true, remap = true })
        vim.keymap.set('x', key, value, { silent = true, remap = true })
        vim.keymap.set('o', key, value, { silent = true, remap = true })
      end
    end,
  },
  { -------------------------
    "kylechui/nvim-surround",
    -------------------------
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
          -- Configuration here, or leave empty to use defaults
      })
    end
  },
  { ------------------------
    'folke/tokyonight.nvim',
    ------------------------
    config = function()
      require('tokyonight').setup({
        style = "night",
        transparent = true,
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
          sidebars = "transparent", -- style for sidebars
          floats = "transparent", -- style for floating windows
        },
      })
      vim.cmd([[colorscheme tokyonight]])
    end
  },
  { ----------------------------
    'nvim-lualine/lualine.nvim',
    ----------------------------
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = false,
          theme = 'auto',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true, -- !!! laststatus = 3 !!!
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {function() return vim.fn.getcwd() end},
          lualine_b = {{'filename', path = 1}},
          lualine_c = {'branch', 'diff', 'diagnostics'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress',
            function() -- https://qiita.com/Liquid-system/items/b95e8aec02c6b0de4235
              local msg = "N/A"
              local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
              local clients = vim.lsp.get_clients()
              if next(clients) == nil then
                return msg
              end
              for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 and client.name ~= "null-ls" then
                  return client.name
                end
              end
              return msg
            end
          },
          lualine_z = {{'datetime', style = '%m/%d %H:%M:%S'}},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end
  },
  { -----------------------
    'lambdalisue/fern.vim',
    -----------------------
    lazy = true,
    keys = {
      { '<Leader>o', '<CMD>Fern . -reveal=%:h -drawer -toggle<CR>' },
    },
    config = function()
      vim.cmd([[
        let g:fern#renderer#default#leading = " "
        let g:fern#renderer#default#root_symbol = ""
        let g:fern#renderer#default#leaf_symbol = "  "
        let g:fern#renderer#default#collapsed_symbol = " "
        let g:fern#renderer#default#expanded_symbol = " "
        let g:fern#default_hidden = 1
        let g:fern#hide_cursor = 1
      ]]) -- https://github.com/lambdalisue/fern.vim/blob/master/doc/fern.txt
      vim.api.nvim_create_augroup('fern', { clear = true })
      vim.api.nvim_create_autocmd({ 'FileType' }, {
        group = 'fern',
        pattern = 'fern',
        command = 'setlocal nonumber | setlocal nocursorcolumn | nmap <buffer> <cr> <Plug>(fern-action-tcd)',
      })
    end
  },
  { --------------------------------
    'nvim-telescope/telescope.nvim',
    --------------------------------
    lazy = true,
    keys = {
      { '<Leader>l', "<CMD>lua require('telescope.builtin').buffers({initial_mode='normal', sort_mru=true})<CR>" },
      { '<Leader>f', "<CMD>lua require('telescope.builtin').find_files()<CR>" },
      { '<Leader>g', "<CMD>lua require('telescope.builtin').live_grep()<CR>" },
    },
    dependencies = {
      { 'nvim-lua/plenary.nvim' }
    },
    config = function()
      require('telescope').setup({
        defaults = {
          sorting_strategy = 'ascending',
          layout_config = {
            prompt_position="top",
          }
        },
        pickers = {
          buffers = {
            mappings = {
              n = {
                ['<Leader>l'] = function() require('telescope.actions').select_default(vim.fn.bufnr('%')) end,
                ['l'] = function() require('telescope.actions').select_default(vim.fn.bufnr('%')) end,
                ['x'] = function() require('telescope.actions').delete_buffer(vim.fn.bufnr('%')) end,
              },
            },
          },
        }
      })
    end
  },
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonUpdate", "MasonLog", "MasonInstall", "MasonUninstall", "MasonUninstallAll" },
    config = true,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim" },
      { "neovim/nvim-lspconfig" },
    },
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },
})
