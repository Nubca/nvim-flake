-- SECTION: basic
vim.opt.encoding = "utf-8"
vim.opt.mouse = "a"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.cmdheight = 1
vim.opt.updatetime = 100
vim.opt.tm = 1000
vim.opt.hidden = true
vim.opt.undofile = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.signcolumn = "yes:2"
vim.opt.ai = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.visualbell = false
vim.opt.errorbells = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.colorcolumn = "100"
vim.opt.showbreak = "↪ "
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.guifont = "JetBrainsMono Nerd Font:h14:w-1"
vim.opt.spell = true
vim.opt.spelllang = "en_us"

vim.opt.shortmess:append({ I = true, c = true })

--vim heresy
vim.cmd.aunmenu({ "PopUp.How-to\\ disable\\ mouse" })
vim.cmd.aunmenu({ "PopUp.-1-" })

-- map leader to <Space>
vim.g.mapleader = " "

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'gj', 'j')
vim.keymap.set('n', 'gk', 'k')

vim.keymap.set('n', '<leader><v>', vim.cmd.UndotreeToggle)

-- stop hiding double quotes in json files
vim.g.indentLine_setConceal = 0

-- SECTION: theme
vim.cmd("colorscheme kanagawa")
-- vim.g.moonflyCursorColor = true
-- vim.g.moonflyNormalFloat = true
-- vim.g.moonflyTerminalColors = true
-- vim.g.moonflyTransparent = true
-- vim.g.moonflyUndercurls = true
-- vim.g.moonflyUnderlineMatchParen = true
-- vim.g.moonflyVirtualTextColor = true
-- vim.cmd.colorscheme("moonfly")
--
vim.g.cursorline_timeout = 0

-- Show spaces when Highlighted
vim.opt.listchars = {
  space = '·',
  trail = '·',
  tab = '>·'
}
vim.api.nvim_create_autocmd({"ModeChanged"}, {
  pattern = {"*:v", "*:V", "*:\x16"},
  callback = function()
    vim.opt.list = true
  end
})
vim.api.nvim_create_autocmd({"ModeChanged"}, {
  pattern = {"v:n", "V:n", "\x16:n"},
  callback = function()
    vim.opt.list = false
  end
})

-- SECTION: colorizer
require("colorizer").setup()
vim.keymap.set("n", "<leader>ct", "<cmd> ColorizerToggle<CR>")

-- SECTION: whichkey
WK = require("which-key")
WK.add({ " ", "<Nop>", { silent = true, remap = false }})
WK.setup()
WK.add({
  {
    { "<leader>c", "<cmd> ColorizerToggle<CR>", desc = "toggle Colorizer" },
  },
  {
    mode = { "v" },
    { "J", ":m '>+1<CR>gv=gv" },
    { "K", ":m '<-2<CR>gv=gv" },
  },
  {
    { "C-d>", "<C-d>zz" },
    { "C-u>", "<C-u>zz" },
    { "n", "nzzzv" },
    { "N", "Nzzzv" },
    { "Q", "<nop>" },
  },
  {
    mode = { "x" },
    { "<leader>p", '"_dP' },
  },
})

require("toggleterm").setup({
  open_mapping = [[<Leader>e]],
  direction = "float",
  autochdir = true,
  insert_mappings = false,
  terminal_mappings = true,
  close_on_exit = true,
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
})
