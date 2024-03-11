return {
    copyring = function()
        local oat = vim.api.nvim_create_augroup("oat", { clear = true })
        -- vim.api.nvim_create_autocmd("FileType", {
        --     pattern = { "typescript", "javascript", "php" },
        --     group = oat,
        --     once = true,
        --     callback = function()
        --         -- print "Update copyring date"
        --         -- -- print vim.fn.expand "%"
        --         -- vim.fn.search "* Copyright (c) "
        --         -- local lines = {}
        --         -- local file = vim.expand "~/.config/nvim/lua/user/oat/template/copyring"
        --         -- for line in io.lines(file) do
        --         --     lines[#lines + 1] = line
        --         -- end
        --
        --         -- vim.fn.setline(".", lines)
        --     end,
        -- })
    end,
}
