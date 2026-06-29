local M = {}

function M.executable_in_path(name)
  local path = os.getenv("PATH") or ""

  for dir in path:gmatch("[^:]+") do
    local full = dir .. "/" .. name
    local f = io.open(full, "rb")
    if f then
      f:close()
      return full
    end
  end

  return nil
end

return M
