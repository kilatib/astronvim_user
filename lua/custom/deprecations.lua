local original_validate = vim.validate
local validator_aliases = {
	b = "boolean",
	c = "callable",
	f = "function",
	n = "number",
	s = "string",
	t = "table",
}

local function normalize_validator(validator)
	if type(validator) == "string" then return validator_aliases[validator] or validator end
	if vim.islist(validator) then return vim.tbl_map(normalize_validator, validator) end
	return validator
end

vim.validate = function(name, value, validator, optional, message)
	if validator ~= nil or type(name) ~= "table" then
		return original_validate(name, value, normalize_validator(validator), optional, message)
	end

	for field, spec in pairs(name) do
		original_validate(field, spec[1], normalize_validator(spec[2]), spec[3], spec[4])
	end
end

local original_diagnostic_config = vim.diagnostic.config

vim.diagnostic.config = function(opts, namespace)
	if type(opts) == "table" and type(opts.jump) == "table" and opts.jump.float ~= nil then
		opts = vim.deepcopy(opts)
		local jump = opts.jump
		local float_opts = jump.float

		if float_opts then
			float_opts = type(float_opts) == "table" and float_opts or {}
			jump.on_jump = function(_, bufnr)
				vim.diagnostic.open_float(vim.tbl_extend("keep", float_opts, {
					bufnr = bufnr,
					scope = "cursor",
					focus = false,
				}))
			end
		end

		jump.float = nil
	end

	return original_diagnostic_config(opts, namespace)
end
