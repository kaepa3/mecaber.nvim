-- module represents a lua module for the plugin
local M = {}

local function dumpTable(table, depth)
  for k, v in pairs(table) do
    if type(v) == "table" then
      print(string.rep("  ", depth) .. k .. ":")
      dumpTable(v, depth + 1)
    else
      print(string.rep("  ", depth) .. k .. ": ", v)
    end
  end
end

M.dump = function(table)
  dumpTable(table, 0)
end

local function create_buffer_name(id)
  local def_name = "mecaber"
  return def_name .. id
end

local function print_stdout(chan_id, data, name)
  print(chan_id, type(data), name)
  local buf_name = create_buffer_name(chan_id)

  local bufId = vim.fn.bufnr(name)
  if bufId == -1 then
    buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_name(buf, buf_name)
  else
    vim.cmd("b " .. bufId)
  end
  for index, value in ipairs(data) do
    print(index, value)
  end
  vim.api.nvim_buf_set_lines(buf, -1, -1, true, data)
  if bufId == -1 then
    vim.cmd("vsplit")
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
  end
end

M.send_mecaber = function(text)
  vim.fn.jobstart({ "mecmd", text }, { on_stdout = print_stdout, stdout_buffered = true })
end

return M
