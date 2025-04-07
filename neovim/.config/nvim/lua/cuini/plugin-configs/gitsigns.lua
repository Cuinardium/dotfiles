-- Safe load gitsigns
local gitsigns = Load_Plugin("gitsigns")

-- Config
gitsigns.setup {
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '┃' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
}
