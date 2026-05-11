return {
  "markdown-preview.nvim",
  ft = { "markdown", "quarto", "rmd" },
  before = function()
    vim.g.mkdp_filetypes = { "markdown", "quarto", "rmd" }
    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_refresh_slow = 0
    vim.g.mkdp_echo_preview_url = 1
    vim.g.mkdp_browserfunc = ""
  end,
  wk = {
    {
      {
        "<leader>m",
        desc = "Markdown",
      },
      {
        "<leader>mt",
        "<cmd>MarkdownPreviewToggle<CR>",
        desc = "Toggle preview",
      },
    },
    { noremap = true, silent = true },
  },
}
