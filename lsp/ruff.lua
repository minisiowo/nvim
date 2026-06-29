---@type vim.lsp.Config
return {
  init_options = {
    settings = {},
  },
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
}
