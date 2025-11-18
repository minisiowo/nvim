return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch       = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },

        -- jedno z poniższych wystarczy, ale mogą być oba
        cmd  = "Neotree",          -- :Neotree <tab> też załaduje plugin
        keys = {
            {
                "<leader>e",
                "<cmd>Neotree toggle<CR>",   -- ← string, nie funkcja
                desc = "Toggle NeoTree",
            },
            {
                "<leader>=",
                "<cmd>vertical resize +5<CR>",
                desc = "NeoTree width +5",
            },
            {
                "<leader>-",
                "<cmd>vertical resize -5<CR>",
                desc = "NeoTree width -5",
            },
        },

        opts = {
            window = {
                width = function()  -- 25 % szerokości ekranu
                    return math.floor(vim.o.columns * 0.25)
                end,
            },
            filesystem = {
                follow_current_file = { enabled = true },
            },
        }
    }
}
