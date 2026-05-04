---Shared Ollama URL helpers for CodeCompanion adapters and Minuet.
---Set OLLAMA_HOST like the Ollama CLI (see https://github.com/olimorris/codecompanion.nvim/blob/main/doc/configuration/adapters-http.md).
---Optionally set OLLAMA_LIGHT_HOST for a second instance (e.g. smaller model on another port).

local M = {}

---@param host string|nil
---@return string|nil
function M.normalize_http_base(host)
	if not host or host == "" then
		return nil
	end
	host = host:gsub("/$", "")
	if not host:match("^https?://") then
		host = "http://" .. host
	end
	return host
end

---Chat / agent / heavy models (default Ollama listen address).
function M.ollama_base()
	return M.normalize_http_base(os.getenv("OLLAMA_HOST")) or "http://127.0.0.1:11434"
end

---Autocomplete / fast prompts — falls back to `ollama_base()` if unset.
function M.ollama_light_base()
	return M.normalize_http_base(os.getenv("OLLAMA_LIGHT_HOST")) or M.ollama_base()
end

return M
