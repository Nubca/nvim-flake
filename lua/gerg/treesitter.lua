vim.g._ts_force_sync_parsing = true

local disabled_filetypes = { "markdown", "quarto", "rmd" }

local function disable_treesitter(lang, buf)
  if vim.tbl_contains({ "markdown", "markdown_inline" }, lang) then
    return true
  end

  return vim.tbl_contains(disabled_filetypes, vim.bo[buf].filetype)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.treesitter.language._complete(),
  group = vim.api.nvim_create_augroup("LoadTreesitter", {}),
  callback = function(args)
    if vim.tbl_contains(disabled_filetypes, vim.bo[args.buf].filetype) then
      return
    end

    vim.treesitter.start()
  end,
})
require("nvim-treesitter").setup({
  modules = {},
  sync_install = false,
  ignore_install = {},
  ensure_installed = {},
  auto_install = false,
  highlight = {
    enable = true,
    disable = disable_treesitter,
    additional_vim_regex_highlighting = false,
  },
})
