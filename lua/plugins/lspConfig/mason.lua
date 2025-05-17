return {
    {
        "mason-org/mason.nvim",
        version = "1.11.0",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
                pip = {
                    upgrade_pip = true,
                },
            })
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        version = "1.32.0",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
            local mason_lspconfig = require("mason-lspconfig")
            local mason_tool_installer = require("mason-tool-installer")

            mason_lspconfig.setup({
                automatic_installation = true,
                ensure_installed = {
                    "asm_lsp",
                    "bashls",
                    "clangd",
                    "ast_grep",
                    "harper_ls",
                    "cssls",
                    "html",
                    "lua_ls",
                    "ts_ls",
                    "jsonls",
                    "pylsp",
                    "vimls",
                    "grammarly"
                },
            })

            mason_tool_installer.setup({
                ensure_installed = {
                    "prettier",
                    "isort",
                },
            })
        end,
    }
}
