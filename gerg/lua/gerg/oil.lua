-- local function is_always_hidden(name)
--   if name == ".git" then return true end
--
--   return false
-- end

require("oil").setup({
  columns = {
    "icon",
    -- "permissions",
    -- "size",
    -- "mtime",
  },
  view_options = {
    -- is_always_hidden = is_always_hidden,
    show_hidden = true,
    natural_order = true,
    case_insensitive = true,
  },
  constrain_cursor = "editable",
  delete_to_trash = true,
  watch_for_changes = true,
})

vim.keymap.set("n", "<leader>tt", "<CMD>Oil<CR>", { desc = "Open containing directory" })

