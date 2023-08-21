local M = {}

local api = vim.api
M.floating_winhdl = nil
M.bufhdl = api.nvim_create_buf(false, true)

api.nvim_buf_set_name(M.bufhdl, "myls://bufferlist")
vim.bo[M.bufhdl].filetype = 'myls'

M.ignore_filetype_list = { 'myls', 'fern', 'TelescopePrompt' }
M.selected_symbol = ' '

-- ==========
-- = Public =
-- ==========
-------------------------
function M.setup(default)
-------------------------
  for key, value in pairs(default) do
    if key == 'selected_symbol' then
      M.selected_symbol = value
    else
      print(key .. " is not acceptable.")
    end
  end
end

-----------------
function M.open()
-----------------
  if M.floating_winhdl ~= nil and api.nvim_win_is_valid(M.floating_winhdl) then
    api.nvim_win_close(M.floating_winhdl, true)
    return
  end

  for _, filetype in pairs(M.ignore_filetype_list) do
    if vim.bo.filetype == filetype then
      return
    end
  end

  local bufinfo_list = M.bufinfo()
  local base_winhdl = api.nvim_get_current_win()
  local selected_index = M.selected(base_winhdl, bufinfo_list)
  local options = M.bufrefresh(selected_index, M.bufhdl, bufinfo_list)
  M.floating_winhdl = api.nvim_open_win(M.bufhdl, true, options)
  api.nvim_win_set_cursor(M.floating_winhdl, {selected_index ,0})
  M.setcommand(M.bufhdl, bufinfo_list, base_winhdl, M.floating_winhdl)
end

-- ===========
-- = Private =
-- ===========
-- -------------- --
-- Listing buffer --
-- -------------- --
function M.bufinfo()
  local bufinfo_list = {}
  for _, value in pairs(api.nvim_list_bufs()) do
    local _bufhdl = value
    name = api.nvim_buf_get_name(_bufhdl) == '' and '[NoName]' or api.nvim_buf_get_name(_bufhdl)

    if api.nvim_buf_is_loaded(_bufhdl) == false then
      -- no listed
    else
      local shown = true
      for _, filetype in pairs(M.ignore_filetype_list) do
        if vim.bo[_bufhdl].filetype == filetype then
          shown = false
        end
      end

      if shown == true then
        table.insert(bufinfo_list, {
          bufhdl = _bufhdl,
          name = name,
          valid = api.nvim_buf_is_valid(_bufhdl),
          loaded = api.nvim_buf_is_loaded(_bufhdl),
        })
      end
    end
  end
  return bufinfo_list
end

-- -------------- --
-- Listing buffer --
-- -------------- --
function M.selected(base_winhdl, bufinfo_list)
  local selected_index = 0
  _bufhdl = api.nvim_win_get_buf(base_winhdl)
  for index, bufinfo in pairs(bufinfo_list) do
    if bufinfo.bufhdl == _bufhdl then
      selected_index = index
    end
  end
  return selected_index
end

-- -------------------------------- --
-- Display and open floating window --
-- -------------------------------- --
function M.bufrefresh(selected_index, bufhdl, bufinfo_list)
  width = 0
  --api.nvim_buf_set_option(bufhdl, 'modifiable', true)
  api.nvim_buf_set_lines(bufhdl, 0, -1, true, (function()
    local display_table = {}
    for index, value in pairs(bufinfo_list) do
      point = (" "):rep(vim.fn.strdisplaywidth(M.selected_symbol))
      if index == selected_index then
        point = M.selected_symbol
      end
      line = point..value.name
      width = math.max(width, #line)
      table.insert(display_table, line)
    end
    return display_table
  end)())
  --api.nvim_buf_set_option(bufhdl, 'modifiable', false)

  local options = {
    relative = "win", width = width+1, height = #bufinfo_list,
    col =( api.nvim_win_get_width(0) - width ) / 2,
    row = api.nvim_win_get_height(0) - #bufinfo_list - 2,
    style = "minimal", border = "rounded",
    title = " buffer list ", title_pos = "center"
  }

  return options
end

-- ----------- --
-- Set autocmd --
-- ----------- --
function M.setcommand(bufhdl, bufinfo_list, base_winhdl, floating_winhdl)
  api.nvim_create_augroup('myls', { clear = true } )
  api.nvim_create_autocmd('BufLeave', {
    group = 'myls',
    buffer = bufhdl,
    callback = function()
      api.nvim_win_close(floating_winhdl, true)
    end,
  })
  api.nvim_create_autocmd('CursorMoved', {
    group = 'myls',
    buffer = bufhdl,
    callback = function()
      local index = api.nvim_win_get_cursor(floating_winhdl)[1]
      local _bufhdl = bufinfo_list[index].bufhdl
      api.nvim_win_set_buf(base_winhdl, _bufhdl)

      local selected_index = M.selected(base_winhdl, bufinfo_list)
      local _ = M.bufrefresh(selected_index, M.bufhdl, bufinfo_list)
    end,
  })
end

return M
