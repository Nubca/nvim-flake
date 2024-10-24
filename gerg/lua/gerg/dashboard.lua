require('dashboard').setup {
  theme = 'hyper',
  config = {
    week_header = {
     enable = true,
    },
    shortcut = {
      {
        icon = ' ',
        desc = 'Find',
        icon_hl = '@variable',
        group = 'Label',
        action = 'Telescope find_files',
        key = 'f',
      },
      {
        icon = ' ',
        desc = 'Apps',
        group = 'DiagnosticHint',
        action = 'Telescope app',
        key = 'a',
      },
      {
        icon = ' ',
        desc = 'Dotfiles',
        group = 'Number',
        action = 'Telescope dotfiles',
        key = 'd',
      },
    },
    project = { enable = true, limit = 5, icon = ' ', label = 'Recent Projects', action = 'Telescope find_files cwd='},
    mru = { limit = 10, icon = ' ', label = 'Recent Files', cwd_only = false },
    footer = {'We do this NOT because it is easy, but because we thought it would be easy.'},
  },
}
