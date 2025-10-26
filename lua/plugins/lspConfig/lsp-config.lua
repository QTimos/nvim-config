return {
    'neovim/nvim-lspconfig',
    dependencies = {
        { 'mason-org/mason.nvim', config = true },
        'mason-org/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        {
            'j-hui/fidget.nvim',
            opts = {
                notification = {
                    window = {
                        winblend = 0,
                    },
                },
            },
        },
        'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
        _G.lsp_diagnostics_config = {
            show_non_error_diagnostics = false
        }

        local function toggle_non_error_diagnostics()
            _G.lsp_diagnostics_config.show_non_error_diagnostics = not _G.lsp_diagnostics_config.show_non_error_diagnostics
            vim.notify("Non-error diagnostics " .. (_G.lsp_diagnostics_config.show_non_error_diagnostics and "enabled" or "disabled"))

            for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(bufnr) then
                    vim.diagnostic.reset(nil, bufnr)
                    local ns = vim.diagnostic.get_namespaces()
                    for ns_id, _ in pairs(ns) do
                        local diagnostics = vim.diagnostic.get(bufnr, {namespace = ns_id})
                        if diagnostics and #diagnostics > 0 then
                            vim.diagnostic.set(ns_id, bufnr, diagnostics)
                        end
                    end
                end
            end
        end

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local opts = function(desc)
                    return { desc = desc, buffer = ev.buf, silent = true }
                end

                vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, opts("Show documentation"))
                vim.keymap.set("n", "<leader>sr", "<cmd>Telescope lsp_references<cr>", opts("Show LSP references"))
                vim.keymap.set("n", "<leader>sdd", vim.lsp.buf.declaration, opts("Go to declaration"))
                vim.keymap.set("n", "<leader>sd", "<cmd>Telescope lsp_definitions<cr>", opts("Show LSP definitions"))
                vim.keymap.set("n", "<leader>si", "<cmd>Telescope lsp_implementations<cr>", opts("Show LSP implementations"))
                vim.keymap.set("n", "<leader>st", "<cmd>Telescope lsp_type_definitions<cr>", opts("Show LSP type definitions"))
                vim.keymap.set({ "n", "v" }, "<leader>sa", vim.lsp.buf.code_action, opts("Show available code actions"))
                vim.keymap.set("n", "<leader>tad", toggle_non_error_diagnostics, opts("Toggle non-error diagnostics"))
            end,
        })

        local function filter_diagnostics(diagnostics)
            if not diagnostics then return {} end

            if not _G.lsp_diagnostics_config.show_non_error_diagnostics then
                local filtered = {}
                for _, d in ipairs(diagnostics) do
                    if d.severity == vim.diagnostic.severity.ERROR then
                        table.insert(filtered, d)
                    end
                end
                return filtered
            end

            return diagnostics
        end

        local publish_diagnostics_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
        vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
            if result and result.diagnostics then
                result.diagnostics = filter_diagnostics(result.diagnostics)
            end
            return publish_diagnostics_handler(err, result, ctx, config)
        end

        local original_diagnostic_set = vim.diagnostic.set
        vim.diagnostic.set = function(namespace, bufnr, diagnostics, opts)
            diagnostics = filter_diagnostics(diagnostics)
            return original_diagnostic_set(namespace, bufnr, diagnostics, opts)
        end

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

        local servers = {
            lua_ls = {
                cmd = { 'lua-language-server' },
                filetypes = { 'lua' },
                root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
                settings = {
                    Lua = {
                        diagnostics = { globals = { 'vim' } },
                        completion = { callSnippet = 'Replace' },
                        runtime = {
                            version = 'LuaJIT',
                        }
                    },
                },
            },
            clangd = {
                cmd = { "clangd", "--background-index" },
                filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
                root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git' },
                init_options = {
                    clangdFileStatus = true,
                },
            },
            pylsp = {
                cmd = { "pylsp" },
                filetypes = { 'python' },
                root_markers = { 'setup.py', 'setup.cfg', 'pyproject.toml', 'requirements.txt', '.git' },
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = { enabled = false },
                            pyflakes = { enabled = false },
                            pylint = { enabled = false },
                            mccabe = { enabled = false },
                            rope_completion = { enabled = false },
                        },
                    },
                },
            },
            ts_ls = {
                cmd = { "typescript-language-server", "--stdio" },
                filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
                root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
            },
            bashls = {
                cmd = { "bash-language-server", "start" },
                filetypes = { 'sh', 'bash' },
                root_markers = { '.git' },
            },
            jsonls = {
                cmd = { "vscode-json-language-server", "--stdio" },
                filetypes = { 'json', 'jsonc' },
                root_markers = { '.git' },
            },
            html = {
                cmd = { "vscode-html-language-server", "--stdio" },
                filetypes = { 'html' },
                root_markers = { '.git' },
            },
            cssls = {
                cmd = { "vscode-css-language-server", "--stdio" },
                filetypes = { 'css', 'scss', 'less' },
                root_markers = { '.git' },
            },
            tailwindcss = {
                cmd = { "tailwindcss-language-server", "--stdio" },
                filetypes = { 'html', 'css', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte' },
                root_markers = { 'tailwind.config.js', 'tailwind.config.cjs', 'tailwind.config.ts', '.git' },
            },
            emmet_ls = {
                cmd = { "emmet-ls", "--stdio" },
                filetypes = { 'html', 'css', 'javascriptreact', 'typescriptreact', 'vue', 'svelte' },
                root_markers = { '.git' },
            },
            svelte = {
                cmd = { "svelteserver", "--stdio" },
                filetypes = { 'svelte' },
                root_markers = { '.git' },
            },
            astro = {
                cmd = { "astro-ls", "--stdio" },
                filetypes = { 'astro' },
                root_markers = { 'astro.config.mjs', 'astro.config.js', 'astro.config.ts', '.git' },
            },
            yamlls = {
                cmd = { "yaml-language-server", "--stdio" },
                filetypes = { 'yaml', 'yml' },
                root_markers = { '.git' },
            },
            graphql = {
                cmd = { "graphql-lsp", "server" },
                filetypes = { 'graphql', 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
                root_markers = { '.git' },
            },
            prismals = {
                cmd = { "prisma-language-server", "--stdio" },
                filetypes = { 'prisma' },
                root_markers = { '.git' },
            },
            dockerls = {
                cmd = { "docker-langserver", "--stdio" },
                filetypes = { 'dockerfile' },
                root_markers = { '.git' },
            },
            sqlls = {
                cmd = { "sql-language-server", "up", "--method", "stdio" },
                filetypes = { 'sql', 'mysql' },
                root_markers = { '.git' },
            },
            rust_analyzer = {
                cmd = { "rust-analyzer" },
                filetypes = { 'rust' },
                root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
            },
            gopls = {
                cmd = { "gopls" },
                filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
                root_markers = { 'go.mod', '.git' },
            },
            jdtls = {
                cmd = { "jdtls" },
                filetypes = { 'java' },
                root_markers = { '.git', 'pom.xml', 'build.gradle', 'build.gradle.kts' },
            },
            vimls = {
                cmd = { "vim-language-server", "--stdio" },
                filetypes = { 'vim' },
                root_markers = { '.git' },
            },
            marksman = {
                cmd = { "marksman", "server" },
                filetypes = { 'markdown' },
                root_markers = { '.git' },
            },
            grammarly = {
                cmd = { "grammarly-languageserver", "--stdio" },
                filetypes = { 'markdown', 'tex', 'latex', 'plaintext' },
                root_markers = { '.git' },
            },
            harper_ls = {
                cmd = { "harper-ls" },
                filetypes = { 'python', 'javascript', 'typescript', 'java', 'c', 'cpp', 'go', 'rust' },
                root_markers = { '.git' },
            },
            kotlin_language_server = {
                cmd = { "kotlin-language-server" },
                filetypes = { 'kotlin' },
                root_markers = { 'settings.gradle', 'settings.gradle.kts', 'build.gradle', 'build.gradle.kts', '.git' },
            },
            vue_ls = {
                cmd = { "vue-language-server", "--stdio" },
                filetypes = { 'vue' },
                root_markers = { 'package.json', 'vue.config.js', '.git' },
                init_options = {
                    typescript = {
                        tsdk = vim.fn.stdpath("data") .. "/mason/packages/typescript/lib",
                    },
                },
            },
            laravel_ls = {
                cmd = { "laravel-ls" },
                filetypes = { 'php' },
                root_markers = { 'composer.json', '.git' },
            },
        }

        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            'stylua',
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        for server, cfg in pairs(servers) do
            cfg.capabilities = vim.tbl_deep_extend('force', {}, capabilities, cfg.capabilities or {})

            vim.lsp.config(server, cfg)
            vim.lsp.enable(server)
        end
    end,
}
