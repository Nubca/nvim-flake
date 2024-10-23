  require('dashboard').setup {
    theme = 'hyper',
    config = {
      week_header = {
       enable = true,
      },
      shortcut = {
        {
          icon = ' Find',
          icon_hl = '@variable',
          group = 'Label',
          action = 'Telescope find_files',
          key = 'f',
        },
        {
          desc = ' Apps',
          group = 'DiagnosticHint',
          action = 'Telescope app',
          key = 'a',
        },
        {
          desc = ' dotfiles',
          group = 'Number',
          action = 'Telescope dotfiles',
          key = 'd',
        },
      },
      packages = { enable = false },
      project = { enable = true, limit = 5, icon = ' ', label = 'Recent Projects', action = 'Telescope find_files cwd='},
      mru = { limit = 10, icon = ' ', label = 'Recent Files', cwd_only = false },
      footer = {"\nWe do this NOT because it is easy,\nbut because we thought it would be easy."
      },
    },
  }
