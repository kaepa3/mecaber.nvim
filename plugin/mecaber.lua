package.loaded["mecaber"] = nil
package.loaded["mecaber.module"] = nil

vim.api.nvim_create_user_command("Mecaber", function(args)
  require("mecaber").mecaber(args)
end, { nargs = "?", range = true })
