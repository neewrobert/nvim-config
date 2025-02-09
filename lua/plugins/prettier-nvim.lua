-- prettier-nvim.lua
return {
  "prettier/vim-prettier",
  run = "npm install",  -- or "yarn install" if you prefer yarn
  ft = { "javascript", "typescript", "html", "css", "json", "lua" },  -- adjust filetypes as needed
  config = function()
    -- Enable autoformat on save
    vim.g["prettier#autoformat"] = 1
    -- Set to 0 if you don't want to require a pragma comment in your file for formatting
    vim.g["prettier#autoformat_require_pragma"] = 0
    
    -- Optional: Map a key to manually trigger Prettier
    vim.api.nvim_set_keymap("n", "<leader>pf", ":Prettier<CR>", { noremap = true, silent = true })
  end,
}
