-- SECTION: treesitter
require("nvim-treesitter.configs").setup({
  modules = {},
  sync_install = false,
  ignore_install = {},
  ensure_installed = {},
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  -- incremental_selection = {
  --   enable = true,
  -- },
})

-- -- Treesitter Context config
-- require("treesitter-context").setup({
--   enable = true,
--   max_lines = 0,
--   min_window_height = 0,
--   line_numbers = true,
--   multiline_threshold = 20,
--   trim_scope = "outer",
--   mode = "cursor",
--   separator = nil,
--   zindex = 20,
--   on_attach = nil,
-- })
--
-- -- rainbow_delimiters
-- local rainbow_delimiters = require("rainbow-delimiters")

-- Rainbows

-- vim.g.rainbow_delimiters = {
--   strategy = {
--     [""] = rainbow_delimiters.strategy["global"],
--     vim = rainbow_delimiters.strategy["local"],
--   },
--   query = {
--     [""] = "rainbow-delimiters",
--     lua = "rainbow-blocks",
--   },
--
-- rainbows

local highlight = {
  "RainbowDelimiterRed",
  "RainbowDelimiterYellow",
  "RainbowDelimiterBlue",
  "RainbowDelimiterOrange",
  "RainbowDelimiterGreen",
  "RainbowDelimiterViolet",
  "RainbowDelimiterCyan",
}
vim.g.rainbow_delimiters = {
  highlight = highlight,
}
local hooks = require("ibl.hooks")
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

require("ibl").setup({
  scope = {
    enabled = true,
    show_start = true,
    show_end = true,
    injected_languages = true,
    highlight = highlight,
  },
  indent = {
    char = "┋",
  },
})
