return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
  root_markers = { ".git" },
  settings = {
    yaml = {
      validate = true,
      hover = true,
      completion = true,
      schemas = {
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
          "docker-compose.yml",
          "docker-compose.yaml",
          "compose.yml",
          "compose.yaml",
        },
      },
    },
  },
}
