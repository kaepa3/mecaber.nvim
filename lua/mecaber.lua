-- main module file
local module = require("mecaber.module")

local M = {}
M.config = {
  -- default config
  opt = "Hello!",
}

-- setup is the public method to setup your plugin
M.setup = function(args)
  -- you can define your setup function here. Usually configurations can be merged, accepting outside params and
  -- you can also put some validation here for those.
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

function get_analyze_text(opts)
  local texts = ""
  if #opts.args > 0 then
    texts = opts.args
  elseif opts.count ~= -1 then
    local st = opts.line1 - 1
    local en = opts.line2 - 1
    local lines = vim.api.nvim_buf_get_lines(0, st, en + 1, false)
    texts = table.concat(lines, "\n")
  else
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
    texts = table.concat(lines, "\n")
  end
  return texts
end

-- start mecaber
M.mecaber = function(opts)
  local texts = get_analyze_text(opts)
  module.send_mecaber(texts)
end

return M
