return {
	strategy = "chat",
	description = "Generate commit messages over 1080 Ti",
	opts = {
		index = 1,
		is_default = true,
		is_slash_cmd = true,
		short_name = "commit7b",
		auto_submit = true,
		adapter = "homeLabLight",
	},
	prompts = {
		{
			role = "system",
			content = "Write a concise git commit message for these changes. Use conventional commits format (e.g., feat:, fix:, chore:, refactor:). Reply ONLY with the commit message, no explanations, no intro. Diff: $DIFF",
		},
		{
			role = "user",
			content = function()
				local diff = vim.fn.system("git diff --staged")
				if diff == "" then
					return "There are no staged changes. First, run git add ."
				end
				return "Data as the changes:\n\n```diff\n" .. diff .. "\n```"
			end,
		},
	},
}
