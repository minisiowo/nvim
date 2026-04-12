-- nasłuchuje zmian w paczkach i pobiera parsery dla treesitter (odpowiednik :TSUpdate w lazy)
vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == 'nvim-treesitter' and kind == 'update' then
    if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
    vim.cmd('TSUpdate')
  end
end })

local rust_format_group = vim.api.nvim_create_augroup("rust_format_on_save", { clear = false })

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("no_auto_comment", {}),
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end,
})

-- Auto save when leaving buffer, losing focus, or leaving insert mode
vim.api.nvim_create_autocmd({"FocusLost", "BufLeave"}, {
    group = vim.api.nvim_create_augroup("auto_save", {}),
    callback = function()
        -- Only save if:
        -- 1. Buffer is modified
        -- 2. Buffer is not read-only
        -- 3. Buffer has a filename (not a new unnamed buffer)
        if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" then
            vim.cmd("silent write")
        end
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("rust_lsp_attach", {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or client.name ~= "rust_analyzer" then
            return
        end

        local buf = args.buf
        if vim.bo[buf].filetype ~= "rust" or not client:supports_method("textDocument/formatting") then
            return
        end
        if vim.fn.executable("rustfmt") ~= 1 then
            return
        end
        if vim.b[buf].rust_format_on_save_attached then
            return
        end
        vim.b[buf].rust_format_on_save_attached = true

        vim.api.nvim_create_autocmd("BufWritePre", {
            group = rust_format_group,
            buffer = buf,
            callback = function()
                vim.lsp.buf.format({
                    bufnr = buf,
                    id = client.id,
                    timeout_ms = 2000,
                })
            end,
        })
    end,
})
