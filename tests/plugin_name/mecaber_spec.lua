local plugin = require("mecaber")

describe("setup", function()
  it("works with custom var", function()
    plugin.setup({ opt = "custom" })
  end)
end)
