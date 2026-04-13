local M = {}

M.setup = function ()
    local miniclue = require("mini.clue")

    require("mini.basics").setup({
        options = {
            extra_ui = true,
        },
    })

    require("mini.pairs").setup()
    require("mini.git").setup()
    require("mini.pick").setup()
    require("mini.surround").setup()
    require("mini.icons").setup()
    miniclue.setup({
        triggers = {
            -- Leader triggers
            { mode = { 'n', 'x' }, keys = '<Leader>' },

            -- `[` and `]` keys
            { mode = 'n', keys = '[' },
            { mode = 'n', keys = ']' },

            -- Built-in completion
            { mode = 'i', keys = '<C-x>' },

            -- `g` key
            { mode = { 'n', 'x' }, keys = 'g' },

            -- Marks
            { mode = { 'n', 'x' }, keys = "'" },
            { mode = { 'n', 'x' }, keys = '`' },

            -- Registers
            { mode = { 'n', 'x' }, keys = '"' },
            { mode = { 'i', 'c' }, keys = '<C-r>' },

            -- Window commands
            { mode = 'n', keys = '<C-w>' },

            -- `z` key
            { mode = { 'n', 'x' }, keys = 'z' },
        },

        clues = {
            { mode = 'n', keys = '<Leader>d', desc = '+diagnostics' },
            { mode = 'n', keys = '<Leader>f', desc = '+find' },
            { mode = 'n', keys = '<Leader>s', desc = '+splits' },
            { mode = 'n', keys = '<Leader>v', desc = '+visual' },
            { mode = 'n', keys = '<Leader>e', desc = 'Explorer' },
            { mode = 'n', keys = '<Leader>o', desc = 'Save and source file' },
            { mode = 'n', keys = '<Leader>R', desc = 'Restart Neovim with session restore' },

            miniclue.gen_clues.square_brackets(),
            miniclue.gen_clues.builtin_completion(),
            miniclue.gen_clues.g(),
            miniclue.gen_clues.marks(),
            miniclue.gen_clues.registers(),
            miniclue.gen_clues.windows(),
            miniclue.gen_clues.z(),
        },
    })
end

return M
