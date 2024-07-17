-- SECTION: lualine
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { "", "" },
    section_separators = { "", "" },
    disabled_filetypes = { "packer", "NvimTree", "alpha" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      {
        "filename",
        color = { bg = "none" },
        symbols = { modified = " ", readonly = " " },
      },
    },
    lualine_c = {
      {
        "branch",
        icon = " =",
        separator = { right = ")" },
      },
    },
    lualine_x = {
      {
        "diagnostics",
        sources = { "nvim_lsp", "nvim_diagnostic" },
        symbols = { error = "", warn = "", info = "", hint = "" },
      },
    },
    lualine_y = {
      {
        "fileformat",
        color = { bg = "none" },
      },
      {
        "progress",
        color = {
          bg = "none",
          fg = "lavender",
        },
      },
      {
        "filetype",
        color = { bg = "none", fg = "lavender" },
      },
    },
    lualine_z = {
      {
        "location",
        -- color = { bg = "none", fg = "lavender" },
      },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = { "filename" },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { "location" },
  },
  tabline = {},
  extensions = { "nvim-tree" },
})
