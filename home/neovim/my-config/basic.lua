local o = vim.o
local g = vim.g

o.guifont = "FiraCode Nerd Font Mono:h12"
o.mouse = "a"
o.clipboard = "unnamedplus"

o.cursorline = true
o.wrap = false

o.splitbelow = true
o.splitright = true

o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true

o.foldmethod = 'expr'
o.foldexpr = 'nvim_treesitter#foldexpr()'
o.foldlevel = 99 -- Unfold everything by default

o.backup = false
o.writebackup = false

o.updatetime = 800

o.signcolumn = "number"
o.number = true

o.completeopt = "menu,preview,noinsert"

g.neovide_remember_window_size = true
g.neovide_input_use_logo = true

if g.neovide then
  g.neovide_cursor_animation_length = 0
  g.neovide_cursor_trail_size = 0
  g.neovide_remember_window_size = true
end

local ts_actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = ts_actions.close,
            }
        }
    },
}
require('telescope').load_extension('fzf')

require("stabilize").setup({
    force = true
})
require("auto-session").setup {
    auto_session_enable_last_session = true,
    auto_session_suppress_dirs = { "/etc" }
}
require("session-lens").setup {
}

