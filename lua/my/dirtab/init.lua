-- https://thinca.hatenablog.com/entry/20111204/1322932585
local M = {}

local function dirtab(options)
  local line = " "
  local current_tabnr = vim.fn.tabpagenr()

  for tabnr = 1, vim.fn.tabpagenr "$" do
    -- https://vim-jp.org/vimdoc-ja/builtin.html#getcwd()
    local cwd = vim.fs.basename(vim.fn.getcwd(vim.fn.tabpagewinnr(tabnr), tabnr))

    if tabnr == current_tabnr then
      line = line .. "%#TabLineSel#  " .. cwd .. " %#TabLineFill#"
    else
      line = line .. "%#TabLine#  " .. cwd .. " %#TabLineFill#"
    end
  end

  return line
end

function M.setup(options)
  options = options or {}

  M.options = vim.tbl_deep_extend("force", {
    enable = true,
  }, options)

  function _G.tabline()
    return dirtab(M.options)
  end

  if M.options.enable then
    vim.opt.tabline = "%!v:lua.tabline()"
  end
end

return M
