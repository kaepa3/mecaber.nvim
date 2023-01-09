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

local exclude_texts = { "BOS/EOS" }

local function is_exclude(text)
  for _, value in ipairs(exclude_texts) do
    if nil ~= string.find(text, value) then
      return true
    end
  end
  return false
end

local function create_output_text(text)
  local output = {}
  for index, value in ipairs(text) do
    if not is_exclude(value) then
      if #value > 0 then
        table.insert(output, value)
      end
    end
  end
  return output
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
  local output = create_output_text(data)
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, output)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
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
