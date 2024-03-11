return {
    "glepnir/template.nvim",
    event = "InsertEnter",
    ft = {
        "php",
        "javascript",
        "typescript",
    },
    config = function()
        require("template").setup {
            temp_dir = vim.fn.expand "~/.config/nvim/lua/user/oat/template",
            email = "vitalii.shtykhno@taotesting.com",
            author = function()
                local lines = {}
                local file = vim.fn.expand "~/.config/nvim/lua/user/oat/template/copyring.tpl"
                for line in io.lines(file) do
                    lines[#lines + 1] = line
                end

                vim.fn.setline(".", lines)
                -- vim.env.lines = table.concat(lines, "\n")
                vim.env.lines = table.concat(lines, "\n"), "[\n\r]"
                print(vim.env.lines)

                return "Vitalii Shtykhno"
            end,
        }
    end,
}
