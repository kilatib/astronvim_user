-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
	"AstroNvim/astrolsp",
	---@type AstroLSPOpts
	opts = function(_, opts)
		local function get_secret(secret_ref)
			local result = vim.fn.system({ "op", "read", secret_ref })
			if vim.v.shell_error ~= 0 then return nil end
			return vim.trim(result)
		end

		opts.formatting = vim.tbl_deep_extend("force", opts.formatting or {}, {
			format_on_save = {
				enabled = false,
				allow_filetypes = {
					"php",
					"javascript",
					"typescript",
				},
				ignore_filetypes = {
					"yaml",
					"yml",
					"json",
				},
			},
			timeout_ms = 1000,
		})


		opts.servers = opts.servers or {}
		if not vim.tbl_contains(opts.servers, "intelephense") then table.insert(opts.servers, "intelephense") end

		opts.config = opts.config or {}

		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.tbl_get(opts, "config", "*", "capabilities") or vim.lsp.protocol.make_client_capabilities(),
			{ textDocument = { completion = { completionItem = { snippetSupport = true } } } }
		)
		local licence_key = get_secret("op://Private/Intelephense/LICENCE KEYS")
		local init_options = {
			globalStoragePath = vim.fn.stdpath("data") .. "/intelephense",
		}
		if licence_key then init_options.licenceKey = licence_key end

		opts.config.intelephense = vim.tbl_deep_extend("force", opts.config.intelephense or {}, {
			capabilities = capabilities,
			init_options = init_options,
			settings = {
				intelephense = {
					files = {
						exclude = {
							"**/.git/**",
							"**/.svn/**",
							"**/.hg/**",
							"**/CVS/**",
							"**/.DS_Store/**",
							"**/node_modules/**",
							"**/bower_components/**",
							"**/.history/**",
						},
					},
					environment = {
						shortOpenTag = false,
						includePaths = {
							"vendor/qtism/qtism/**",
							"vendor/**",
						},
						phpVersion = "8.2",
					},
				},
			},
		})

		return opts
	end,
}
