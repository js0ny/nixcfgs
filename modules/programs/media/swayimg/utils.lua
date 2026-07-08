local M = {}

M.shell_quote = function(value)
  return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

M.chomp = function(s)
  return s:gsub('\r?\n$', '')
end

M.add = function(a, b)
  return a + b
end

M.sub = function(a, b)
  return a - b
end

local function basename(path)
  return tostring(path):match('([^/]+)$') or tostring(path)
end

local function format_size(size)
  if type(size) ~= 'number' then
    return tostring(size or '')
  end

  local units = { 'B', 'KiB', 'MiB', 'GiB' }
  local value = size
  local unit = 1

  while value >= 1024 and unit < #units do
    value = value / 1024
    unit = unit + 1
  end

  if unit == 1 then
    return string.format('%d %s', value, units[unit])
  end

  return string.format('%.1f %s (%d bytes)', value, units[unit], size)
end

local function format_time(time)
  if type(time) ~= 'number' then
    return tostring(time or '')
  end

  return os.date('%Y-%m-%d %H:%M:%S', time)
end

local function meta_value(meta, path)
  local value = meta

  for part in path:gmatch('[^.]+') do
    if type(value) ~= 'table' then
      return nil
    end

    value = value[part]
  end

  if value == nil or value == '' then
    return nil
  end

  return tostring(value)
end

local function add_line(lines, label, value)
  if value ~= nil and value ~= '' then
    table.insert(lines, string.format('%s: %s', label, value))
  end
end

M.show_properties = function(img)
  if not img then
    return
  end

  local lines = {}
  add_line(lines, 'Name', basename(img.path))
  add_line(lines, 'Path', img.path)
  add_line(lines, 'Format', img.format)

  if img.width and img.height then
    add_line(lines, 'Dimensions', string.format('%dx%d', img.width, img.height))
  end

  add_line(lines, 'Frames', img.frames)
  add_line(lines, 'Size', format_size(img.size))
  add_line(lines, 'Modified', format_time(img.mtime))
  add_line(lines, 'Index', img.index)
  add_line(lines, 'Marked', img.mark and 'yes' or nil)

  local meta = img.meta
  if type(meta) == 'table' then
    add_line(lines, 'Date taken', meta_value(meta, 'Exif.Photo.DateTimeOriginal'))
    add_line(lines, 'Camera make', meta_value(meta, 'Exif.Image.Make'))
    add_line(lines, 'Camera model', meta_value(meta, 'Exif.Image.Model'))
    add_line(lines, 'Lens', meta_value(meta, 'Exif.Photo.LensModel'))
    add_line(lines, 'Exposure', meta_value(meta, 'Exif.Photo.ExposureTime'))
    add_line(lines, 'Aperture', meta_value(meta, 'Exif.Photo.FNumber'))
    add_line(lines, 'ISO', meta_value(meta, 'Exif.Photo.ISOSpeedRatings'))
    add_line(lines, 'Focal length', meta_value(meta, 'Exif.Photo.FocalLength'))
  end

  local text = M.shell_quote(table.concat(lines, '\n'))
  os.execute(
    "zenity --info --no-wrap --title 'Image Properties' --text " .. text .. ' >/dev/null 2>&1 &'
  )
end

M.cmd_stdout = function(cmd)
  local handle = io.popen(cmd)
  if handle == nil then
    return nil, 'failed to spawn command'
  end

  local output = handle:read('*a')
  local ok, reason, code = handle:close()

  if not ok then
    return nil, string.format('command failed: %s %s', tostring(reason), tostring(code))
  end

  return output
end

return M
