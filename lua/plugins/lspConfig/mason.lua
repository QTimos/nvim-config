return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",             -- Lua
                    "clangd",             -- C/C++
                    "pylsp",              -- Python
                    "ts_ls",              -- TypeScript/JavaScript
                    "bashls",             -- Bash
                    "jsonls",             -- JSON
                    "html",               -- HTML
                    "cssls",              -- CSS
                    "laravel_ls",         -- PHP
                    "tailwindcss",        -- Tailwind CSS
                    "emmet_ls",           -- Emmet
                    "svelte",             -- Svelte
                    "astro",              -- Astro
                    "yamlls",             -- YAML
                    "graphql",            -- GraphQL
                    "prismals",           -- Prisma
                    "dockerls",           -- Docker
                    "sqlls",              -- SQL
                    "rust_analyzer",      -- Rust
                    "gopls",              -- Go
                    "jdtls",              -- Java
                    "vimls",              -- VimScript
                    "marksman",           -- Markdown
                    "grammarly",          -- Grammar
                    "harper_ls",          -- Spell check
                    "kotlin_language_server", -- Kotlin
                    "vue_ls",             -- Vue-language-server
                },
            })
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "prettier",
                    "prettierd",
                    "stylua",
                    "black",
                    "isort",
                    "clang-format",
                    "shfmt",
                    "eslint_d",
                    "stylelint",
                    "shellcheck",
                    "cpplint",
                    "pylint",
                    "debugpy",
                    "codelldb",
                },
            })
        end,
    }
}
