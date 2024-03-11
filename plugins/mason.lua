-- customize mason plugins
return {
    -- use mason-lspconfig to configure LSP installations
    {
        "williamboman/mason-lspconfig.nvim",
        -- overrides `require("mason-lspconfig").setup(...)`
        opts = function(_, opts)
            -- add more things to the ensure_installed table protecting against community packs modifying it
            opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
                "lua_ls",
                "ansiblels",
                "bashls",
                "dockerls",
                "docker_compose_language_service",
                "jsonls",
                "tsserver",
                "marksman",
                "intelephense",
                -- "phpactor",
                "yamlls",
            })

            local lspconfig = require "lspconfig"
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            lspconfig.intelephense.setup {
                capabilities = capabilities,
                settings = {
                    intelephense = {
                        references = {
                            excluded = {
                                "**/vendor/**/{Tests,tests}/**",
                            },
                        },
                        environment = {
                            includePaths = {
                                "./tests",
                                "./src",
                                "./vendor",
                                "./tests/**",
                                "./src/**",
                                "./vendor/**",
                                "**/vendor/**",
                                "**/vendor/**/runtime/**",
                                "**/src/**",
                                "**/tests/**",
                            },
                            phpVersion = "8.2",
                        },
                    },
                },
            }
        end,
    },
    -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
    {
        "jay-babu/mason-null-ls.nvim",
        -- overrides `require("mason-null-ls").setup(...)`
        opts = function(_, opts)
            -- add more things to the ensure_installed table protecting against community packs modifying it
            opts.ensure_installed = require("astronvim.utils").list_insert_unique(opts.ensure_installed, {
                "prettier",
                "stylua",
            })
        end,
    },
}
