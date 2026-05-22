---@type vim.lsp.Config
return {
  on_attach = function(client, bufnr)
    if client.name == 'nil_ls' then
      client.server_capabilities.definitionProvider = false -- use nixd
    end
  end,
}
