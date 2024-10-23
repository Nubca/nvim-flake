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
  default_file_explorer = true,
  skip_confirm_for_simple_edits = true,
  delete_to_trash = true,
  watch_for_changes = true,
  win_options = {
    wrap = true,
  },
  float = {
    padding = 5,
    border = "rounded",
  },
  preview = {
    border = "rounded",
  },
})
WK.add({
  { "<leader>tt", "<CMD>Oil --float<CR>", desc = "Open containing directory" },
})
