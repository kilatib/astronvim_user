-- Neovim 0.12 lets Tree-sitter queries operate on a string source (as blink.cmp
-- does while rendering a completion item), not only on a buffer number.
local function has_html_text(root, source)
	if root:type() == "text" then
		return vim.treesitter.get_node_text(root, source):find("<", 1, true) ~= nil
	end

	for child in root:iter_children() do
		if has_html_text(child, source) then return true end
	end

	return false
end

local function contains_type(node, node_type)
	if node:type() == node_type then return true end
	for child in node:iter_children() do
		if contains_type(child, node_type) then return true end
	end
	return false
end

vim.treesitter.query.add_predicate("php-template-language?", function(match, _, source, pred)
	local node = match[pred[2]]
	node = node and (node[1] or node)
	if not node then return false end

	local root = node
	while root:parent() do root = root:parent() end

	if not has_html_text(root, source) or contains_type(node, "text") then return false end
	local parent = node:parent()
	return parent ~= nil and contains_type(parent, "text")
end, { force = true })
