local function is_always_hidden(name)
  if name == ".git" then return true end

  return false
end

require("oil").setup({
  columns = { "icon", "permissions", "size", "mtime", },
  view_options = {
    show_hidden = true,
    is_always_hidden = is_always_hidden,
  },
})

vim.keymap.set("n", "<leader>tt", "<CMD>Oil<CR>", { desc = "Open parent directory" })

local wk = require("which-key")
wk.add({
  o = {
    name = "oil file explorer",
    ["."] = { "<cmd>Oil<cr>", "Open containing directory", },
  },
}, { prefix = "<leader>", })
