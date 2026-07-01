-- Customize Mason

---@type LazySpec
return {
	-- use mason-tool-installer for automatically installing Mason packages
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		-- overrides `require("mason-tool-installer").setup(...)`
		opts = {
			-- Make sure to use the names found in `:Mason`
			ensure_installed = {
				-- install language servers
				"lua-language-server",
				"ansible-language-server",
				"bash-language-server",
				"dockerfile-language-server",
				"docker-compose-language-service",
				"typescript-language-server",
				"json-to-struct",
				"intelephense",
				"yaml-language-server",

				-- install formatters
				"prettierd",
				"stylua",
				"phpcbf",
				"cspell",
				"codespell",
				"phpcs",
				"xmlformatter",
				"eslint_d",
				"eslint-lsp",
				"biome",
				"jsonnetfmt",

				-- install debuggers
				"debugpy",
				"php-debug-adapter",

				-- install any other package
				"tree-sitter-cli",
			},
			auto_update = true,
		},
	},
}
