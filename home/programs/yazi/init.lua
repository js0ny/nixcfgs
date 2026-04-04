function Linemode:size_and_mtime()
  local time = math.floor(self._file.cha.mtime or 0)
  if time == 0 then
    time = ""
  elseif time == 0 or os.date("%Y-%m-%d", time) == "1970-01-01" then
    time = ""
  elseif os.date("%Y", time) == os.date("%Y") then
    time = os.date("%m-%d %H:%M", time)
  else
    time = os.date("%Y-%m-%d", time)
  end

  local size = self._file:size()
  local size_str = size and ya.readable_size(size) or "-"

  if time == "" then
    return size_str
  else
    return string.format("%s %s", size_str, time)
  end
end

Status:children_add(function(self)
  local h = self._current.hovered
  if h and h.link_to then
    local target = tostring(h.link_to)

    if target:find("^/nix/store/") then
      -- 将 32 位 Hash 替换为 /nix/.../，保留包名和后续路径
      local simplified = target:gsub("^/nix/store/[a-z0-9]+%-", "/nix/.../")
      return ui.Span(" -> " .. simplified):fg("darkgray")
    else
      return ui.Span(" -> " .. target):fg("darkgray")
    end
  else
    return ""
  end
end, 3300, Status.LEFT)

-- Plugin setups
require("starship"):setup()
require("git"):setup()
