local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    {
        "saghen/blink.cmp",
        dependencies = { "rafamadriz/friendly-snippets" },
        version = "*",
        opts = {
            keymap = {
                preset = "enter",
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
            },
            appearance = {
                nerd_font_variant = "mono",
            },

            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" },
            completion = {
                keyword = { range = "prefix" },
                menu = {
                    draw = {
                        treesitter = { "lsp" },
                    },
                },
                trigger = { show_on_trigger_character = true },
                documentation = {
                    auto_show = true,
                },
            },

            signature = { enabled = true },
        },
        opts_extend = { "sources.default" },
    },
    {
        "mason-org/mason.nvim",
        opts = {}
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
        require("nvim-tree").setup {}
        end,
    },
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons'
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
            opts = {
        },
        keys = {
            {
                "<leader>?",
                function()
                require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8', branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        'numToStr/Comment.nvim',
        opts = {
            toggler = {
                line = '<C-/>',
            },
            opleader = {
                line = '<C-/>',
            },
        }
    },
    {
        'stevearc/conform.nvim',
        opts = {
            formatters_by_ft = {
                lua = { 'stylua' },
                javascript = { 'prettier' },
                typescript = { 'prettier' },
                python = { 'black' },
                go = { 'gofmt' },
            },
        },
    }
})
