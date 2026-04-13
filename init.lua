-- 1. NAJPIERW: opcje i skróty (szczególnie vim.g.mapleader!)
require("config.options")
require("config.keymaps")
require("config.autocommands")

-- 2. POBIERANIE WTYCZEK
vim.pack.add({
    "https://github.com/rebelot/kanagawa.nvim",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
    "https://github.com/christoomey/vim-tmux-navigator",
    { src = "https://github.com/Saghen/blink.cmp", version = "v1" },
    "https://github.com/rafamadriz/friendly-snippets",
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range('3') },
    -- dependencies
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/MunifTanjim/nui.nvim",
})

-- 3. WYGLĄD I MOTYW (UI powinno załadować się jak najszybciej)
require("kanagawa").setup({
    transparent = true,
    overrides = function(colors)
        local theme = colors.theme
        return {
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MiniPickPrompt = { bg = "none" },
            MiniPickPromptPrefix = { bg = "none" },
            -- blink.cmp – przezroczyste menu i dokumentacja
            BlinkCmpMenu                = { link = "NormalFloat" },
            BlinkCmpMenuBorder          = { link = "FloatBorder" },
            BlinkCmpDocumentation       = { link = "NormalFloat" },
            BlinkCmpDocumentationBorder = { link = "FloatBorder" },
            BlinkCmpMenuSelection       = { bg = "none", fg = theme.syn.special1, bold = true, underline = false },

        }
    end,
    colors = {
        theme = {
            all = {
                ui = {
                    bg_gutter = "none"
                }
            }
        }
    },
})

vim.cmd("colorscheme kanagawa-dragon")

-- 4. KONFIGURACJA WTYCZEK
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

require("blink.cmp").setup({
    keymap = { preset = "default" },
    appearance = {
        nerd_font_variant = "mono",
    },
    completion = {
        documentation = { auto_show = false },
    },
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = {
        -- "prefer_rust" or "lua"
        implementation = "prefer_rust",
        -- prebuilt_binaries = {
        --     force_version = "v1.10.2",
        -- },
    },
})

require("render-markdown").setup({
    heading = {
        icons = {"# ", "## ", "### ", "#### ","##### ","###### "},
        width = "block",
    },
})

require("neo-tree").setup({
    close_if_last_window = true,

    default_component_configs = {
        icon = {
            folder_closed = "+",
            folder_open = "-",
            folder_empty = "∅",
            folder_empty_open = "∅",  -- brakujące pole
            provider = function() end,
            default = "",
            use_filtered_colors = true,  -- brakujące pole
        },
        git_status = {
            symbols = {
                added     = "[A]",
                modified  = "[M]",
                deleted   = "[D]",
                renamed   = "[R]",
                untracked = "[?]",
                ignored   = "[ ]",
                unstaged  = "[u]",
                staged    = "[s]",
                conflict  = "[!]",
            },
        },
    },

    window = {
        width = 35,
        mappings = {
            ["l"] = "open",
            ["h"] = "close_node",
        },
    },

    filesystem = {
        filtered_items = {
            hide_dotfiles = false,
        },
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
    },
})

-- 5 KONFIGURACJA TREESITTER (kolorowanie składni)
require('nvim-treesitter').install({
    "c", "lua", "vim", "vimdoc", "query",
    "html", "css", "javascript", "typescript", "python",
    "rust", "markdown", "markdown_inline",
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function()
        -- Uruchamia kolorowanie składni z użyciem pobranych parserów
        pcall(vim.treesitter.start)
    end,
})

-- 5. KONFIGURACJA LSP I MASONA
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
    ensure_installed = {
        "lua_ls", "html", "cssls",
        "ts_ls", "pyright", "marksman",
        {
            "rust_analyzer",
            condition = function()
                return vim.fn.executable("cargo") == 1
            end,
        },
    }
})

-- Nowy, wbudowany sposób w Neovimie 0.12 na odpalenie serwera
vim.lsp.enable({ "lua_ls", "html", "cssls", "ts_ls", "pyright", "rust_analyzer" })
