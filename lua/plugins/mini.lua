local M = {}

M.setup = function ()
    require("mini.basics").setup({
        options = {
            extra_ui = true,
        },
    })

    require("mini.pairs").setup()
    require("mini.git").setup()
    require("mini.pick").setup()
    require("mini.surround").setup()
    require("mini.icons").setup()
end

return M
