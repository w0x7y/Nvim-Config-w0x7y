return {
    -- OneDarkPro
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000,
        config = function()
            vim.cmd("colorscheme onedark")
        end,
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local telescope = require("telescope")

            telescope.setup({
                defaults = {
                    -- Options: 'horizontal', 'vertical', 'center', 'cursor'
                    layout_strategy = "horizontal", -- Use horizontal layout for search results
                    layout_config = {
                        horizontal = {
                            prompt_position = "bottom", -- Put search bar at the top
                            preview_width = 0.55,
                        },
                    },
                    sorting_strategy = "ascending", -- Match the 'top' prompt position

                    -- Keeps the UI clean by showing the filename first, then the path
                    path_display = { "filename_first" },

                    -- Ignore folders you don't want to search through
                    file_ignore_patterns = { "node_modules", ".git/", "bin/", "obj/" },
                },
            })

            -- Keymaps
            vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, {})
            vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, {})
            vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, {}) -- Search open tabs/buffers
        end,
    },

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- lsp
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    -- Automatically install both LSPs and formatters
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    -- LSPs
                    "clangd",
                    "omnisharp",
                    "lua_ls",
                    "pyright",
                    -- Formatters
                    "stylua",       -- Lua
                    "csharpier",    -- C#
                    "clang-format", -- C++
                    "black",        -- Python
                },
            })
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                -- Managed via mason-tool-installer now, but keeping it safe
                ensure_installed = { "clangd", "omnisharp", "lua_ls", "pyright" },
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = { "williamboman/mason-lspconfig.nvim" },
        config = function()
            -- 1. Configure servers that need custom settings (C# and Lua)
            vim.lsp.config("omnisharp", {
                cmd = { "omnisharp" },
            })

            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                    },
                },
            })

            -- 2. Enable all your servers
            vim.lsp.enable({ "clangd", "omnisharp", "lua_ls", "pyright" })
        end,
    },

    -- The Formatter Engine
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local conform = require("conform")

            conform.setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    cs = { "csharpier" },
                    cpp = { "clang-format" },
                    c = { "clang-format" },
                    python = { "black" },
                },
                -- Automatically format when you save a file
                format_on_save = {
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000, -- C# and C++ can sometimes take a brief moment
                },
            })

            -- Optional: Manual format keymap (Space + m + p)
            vim.keymap.set({ "n", "v" }, "<leader>jf", function()
                conform.format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 1000,
                })
            end, { desc = "Format file or range (in visual mode)" })
        end,
    },
    -- Auto-completion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                }),
            })
        end,
    },

    -- Better status line(Lualine)
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    icons_enabled = true,
                },
            })
        end,
    },

    -- ToggleTerminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                size = function(term)
                    if term.direction == "horizontal" then
                        return 30
                    elseif term.direction == "vertical" then
                        return vim.o.columns * 0.5
                    end
                end,
                open_mapping = [[<c-\>]],
                hide_numbers = true,      -- Hide line numbers in terminal buffers
                shade_terminals = true,
                start_in_insert = true,   -- Automatically go into Insert mode when opened
                insert_mappings = true,   -- Whether open mapping applies in insert mode
                terminal_mappings = true, -- Whether open mapping applies in the opened terminal
                persist_size = true,
                direction = "float",      -- "horizontal" | "vertical" | "float"
                close_on_exit = true,     -- Close the terminal window when the process exits
                shell =
                [[C:\Users\idang\AppData\Local\Microsoft\WindowsApps\Microsoft.PowerShell_8wekyb3d8bbwe\pwsh.exe]],
                float_opts = {
                    border = "curved", -- 'single' | 'double' | 'shadow' | 'curved'
                    winblend = 20,     -- Slight transparency
                },
            })

            -- Convenient keymaps for navigating inside the terminal
            function _G.set_terminal_keymaps()
                local opts = { buffer = 0 }
                -- Press 'jk' or 'Caps + Esc' alternatives to exit terminal mode back to normal mode
                vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
                vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)

                -- Easy window navigation from inside the terminal
                vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
                vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
                vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
                vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
            end

            -- Only apply these mappings when a toggleterm opens
            vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
        end,
    },

    -- Git signs
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end,
    },

    -- Auto pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },

    -- Commenting
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },

    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup()
            vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
        end,
    },

    -- Indent blankline
    -- {
    -- 	"lukas-reineke/indent-blankline.nvim",
    -- 	main = "ibl",
    -- 	opts = {
    -- 		indent = { char = "│" },
    -- 		scope = { enabled = true }, -- Highlights the active block scope your cursor is in
    -- 		exclude = {
    -- 			filetypes = {
    -- 				"dashboard",
    -- 				"lazy",
    -- 				"mason",
    -- 				"help",
    -- 				"NvimTree",
    -- 			},
    -- 		},
    -- 	},
    -- },

    -- Snacks.nvim
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            bigfiles = {
                ---@class snacks.bigfile.Config
                ---@field enabled? boolean
                {
                    notify = true,            -- show notification when big file detected
                    size = 1.5 * 1024 * 1024, -- 1.5MB
                    line_length = 1000,       -- average line length (useful for minified files)
                    -- Enable or disable features when big file detected
                    ---@param ctx {buf: number, ft:string}
                    setup = function(ctx)
                        if vim.fn.exists(":NoMatchParen") ~= 0 then
                            vim.cmd([[NoMatchParen]])
                        end
                        Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
                        vim.b.completion = false
                        vim.b.minianimate_disable = true
                        vim.b.minihipatterns_disable = true
                        vim.schedule(function()
                            if vim.api.nvim_buf_is_valid(ctx.buf) then
                                vim.bo[ctx.buf].syntax = ctx.ft
                            end
                        end)
                    end,
                },
            },
            dashboard = { enabled = true },
            indent = {
                animate = {
                    enabled = vim.fn.has("nvim-0.10") == 1,
                    style = "out",
                    easing = "linear",
                    duration = {
                        step = 5,    -- ms per step
                        total = 500, -- maximum duration
                    },
                },
            },
            lazygit = { enabled = true },
            quickfile = { enabled = true }, -- Instantly loads file text before heavy extensions run
            animate = { enabled = true },
            scroll = { enabled = true },
            words = { enabled = true },     -- Highlights matching variables under cursor
        },
        keys = {
            -- Shortcut to open the floating LazyGit window (<leader>gg)
            { "<leader>gg", function() require("snacks").lazygit() end,          desc = "LazyGit" },

            -- Shortcut to open LazyGit history for the current file (<leader>gf)
            { "<leader>gf", function() require("snacks").lazygit.log_file() end, desc = "LazyGit Current File History" },
        },
    },
}
