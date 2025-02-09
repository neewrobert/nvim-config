return {
  "pocco81/auto-save.nvim",
  event = "InsertLeave",
  config = function ()
    require("auto-save").setup({
      enabled =  true,
      execution_message = { enabled = false },
      events = { "InsertLeave", "TextChanged" },
      debounce_delay = 1000,
    })
  end
}
