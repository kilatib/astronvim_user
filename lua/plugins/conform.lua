return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			["php.dist"] = { "php-cs-fixer" },
			php = { "php-cs-fixer" },
			lua = { "stylua" },
			xml = { "xmlformatter" },
			jsonnet = { "jsonnetfmt" },
			["xml.dist"] = { "xmlformatter" },

			-- You can customize some of the format options for the filetype (:help conform.format)
			rust = { "rustfmt", lsp_format = "fallback" },
			-- Conform will run the first available formatter
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			svetle = { "prettierd", "prettier", stop_after_first = true },
			html = { "htmlbeautifier" },
		},
		formatters = {
			["php-cs-fixer"] = {
				command = "/opt/homebrew/bin/php-cs-fixer",
				env = { PHP_CS_FIXER_IGNORE_ENV = "1" },
				args = {
					"fix",
					"--diff",
					-- "--config=phpcs.xml.dist",
					-- "--rules=@PSR12", -- Formatting preset. Other presets are available, see the php-cs-fixer docs.
					"$FILENAME",
				},
				stdin = false,
			},
			["prettierd"] = {
				command = "prettierd",
				env = {
					string.format(
						"PRETTIERD_DEFAULT_CONFIG=%s",
						vim.fn.expand("~/.config/nvim/lua/plugins/conf/prettier-config/index.json")
					),
				},
				args = { "--stdin-filepath", "$FILENAME" },
				root_patterns = {
					".prettierrc",
					".prettierrc.json",
					".prettierrc.yaml",
					".prettierrc.yml",
					".prettierrc.js",
					".prettierrc.cjs",
					".prettierrc.config.js",
					"package.json",
				},
			},
		},
		notify_on_error = true,
		format_on_save = true,
	},
}
