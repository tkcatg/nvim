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
  { -------------------------
    'machakann/vim-sandwich',
    -------------------------
    config = function() -- https://qiita.com/seroqn/items/180e8414c0b9b2431648
      vim.cmd([[
        let g:sandwich_no_default_key_mappings = 1
        let g:operator_sandwich_no_default_key_mappings = 1
        nmap ys <Plug>(operator-sandwich-add)
        nmap <silent>ds <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
        nmap <silent>cs <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
      ]])
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
              local clients = vim.lsp.get_active_clients()
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
                ['x'] = function() require('telescope.actions').delete_buffer(vim.fn.bufnr('%')) end,
                ['n'] = function() require('telescope.actions').close(vim.fn.bufnr('%')) end,
              },
            },
          },
        }
      })
    end
  },
  { -------------------------
    'TimUntersberger/neogit',
    -------------------------
    requires = {
      { 'nvim-lua/plenary.nvim' }
    },
    config = function()
      require('neogit').setup { }
    end
  },
  { --------------------------
    'williamboman/mason.nvim', -- after 'williamboman/nvim-esp-installer'
    --------------------------
    dependencies = {
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/nvim-cmp' },
    },
    config = function()
      require('mason').setup()
      require('cmp').setup({ sources = { { name = 'nvim_lsp' } } })
      require('mason-lspconfig').setup_handlers({
        function(server_name)
          local opts = {
            capabilities = require('cmp_nvim_lsp').default_capabilities()
          }
          -- opts.on_attach = function(_, bufnr)
          --   local bufopts = { silent = true, buffer = bufnr }
          --   vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          --   vim.keymap.set('n', 'gtD', vim.lsp.buf.type_definition, bufopts)
          --   vim.keymap.set('n', 'grf', vim.lsp.buf.references, bufopts)
          --   vim.keymap.set('n', '<space>p', vim.lsp.buf.format, bufopts)
          -- end
          require('lspconfig')[server_name].setup(opts)
        end
      })
    end
  },
})
