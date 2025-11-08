local M = {}

-- Get the .ff-pins file path (project root)
local function get_pins_file()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error == 0 and git_root then
    return git_root .. "/.ff-pins"
  end
  return vim.fn.getcwd() .. "/.ff-pins"
end

-- Read pins file and return {files = {...}, patterns = {...}}
function M.read_pins()
  local pins_file = get_pins_file()
  local files = {}
  local patterns = {}

  local f = io.open(pins_file, "r")
  if not f then
    return { files = files, patterns = patterns }
  end

  for line in f:lines() do
    line = vim.trim(line)
    -- Skip empty lines and comments
    if line ~= "" and not line:match("^#") then
      -- If line contains * or **, treat as glob pattern
      if line:match("%*") then
        table.insert(patterns, line)
      else
        table.insert(files, line)
      end
    end
  end

  f:close()
  return { files = files, patterns = patterns }
end

-- Write pins back to file
function M.write_pins(pins)
  local pins_file = get_pins_file()
  local f = io.open(pins_file, "w")
  if not f then
    vim.notify("Failed to write " .. pins_file, vim.log.levels.ERROR)
    return false
  end

  -- Write explicit files
  if #pins.files > 0 then
    f:write("# Explicit files\n")
    for _, file in ipairs(pins.files) do
      f:write(file .. "\n")
    end
  end

  -- Write patterns
  if #pins.patterns > 0 then
    if #pins.files > 0 then
      f:write("\n")
    end
    f:write("# Glob patterns\n")
    for _, pattern in ipairs(pins.patterns) do
      f:write(pattern .. "\n")
    end
  end

  f:close()
  return true
end

-- Add current file to pins
function M.add_current_file()
  local current_file = vim.fn.expand("%:p")
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

  -- Make path relative to git root if possible
  if vim.v.shell_error == 0 and git_root then
    current_file = current_file:gsub("^" .. vim.pesc(git_root) .. "/", "")
  end

  local pins = M.read_pins()

  -- Check if already pinned
  for _, file in ipairs(pins.files) do
    if file == current_file then
      vim.notify("Already pinned: " .. current_file, vim.log.levels.INFO)
      return
    end
  end

  table.insert(pins.files, current_file)
  if M.write_pins(pins) then
    vim.notify("Pinned: " .. current_file, vim.log.levels.INFO)
  end
end

-- Add a pattern
function M.add_pattern()
  vim.ui.input({ prompt = "Enter keyword: " }, function(input)
    if not input or input == "" then
      return
    end

    -- Create two patterns: one for filenames, one for directories
    local filename_pattern = "**/*" .. input .. "*"
    local directory_pattern = "**/" .. input .. "/**"

    local pins = M.read_pins()
    local added = {}

    -- Add filename pattern if not exists
    local filename_exists = false
    for _, existing_pattern in ipairs(pins.patterns) do
      if existing_pattern == filename_pattern then
        filename_exists = true
        break
      end
    end
    if not filename_exists then
      table.insert(pins.patterns, filename_pattern)
      table.insert(added, filename_pattern)
    end

    -- Add directory pattern if not exists
    local directory_exists = false
    for _, existing_pattern in ipairs(pins.patterns) do
      if existing_pattern == directory_pattern then
        directory_exists = true
        break
      end
    end
    if not directory_exists then
      table.insert(pins.patterns, directory_pattern)
      table.insert(added, directory_pattern)
    end

    if #added > 0 then
      if M.write_pins(pins) then
        vim.notify("Added patterns:\n  " .. table.concat(added, "\n  "), vim.log.levels.INFO)
      end
    else
      vim.notify("Patterns already exist for: " .. input, vim.log.levels.INFO)
    end
  end)
end

-- Clear all pins and patterns
function M.clear_all()
  local pins_file = get_pins_file()
  local f = io.open(pins_file, "w")
  if f then
    f:close()
    vim.notify("Cleared all pins and patterns", vim.log.levels.INFO)
  end
end

-- View current pins and patterns
function M.view_pins()
  local pins = M.read_pins()
  local lines = { "=== Pinned Files ===" }

  if #pins.files == 0 then
    table.insert(lines, "(none)")
  else
    for _, file in ipairs(pins.files) do
      table.insert(lines, "  " .. file)
    end
  end

  table.insert(lines, "")
  table.insert(lines, "=== Glob Patterns ===")
  if #pins.patterns == 0 then
    table.insert(lines, "(none)")
  else
    for _, pattern in ipairs(pins.patterns) do
      table.insert(lines, "  " .. pattern)
    end
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

-- Get all files (expanded patterns + explicit files)
function M.get_all_files()
  local pins = M.read_pins()
  local all_files = {}
  local seen = {}

  -- Add explicit files
  for _, file in ipairs(pins.files) do
    if not seen[file] then
      table.insert(all_files, file)
      seen[file] = true
    end
  end

  -- Expand patterns using fd or find
  for _, pattern in ipairs(pins.patterns) do
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    local search_dir = vim.v.shell_error == 0 and git_root or vim.fn.getcwd()

    -- Use fd if available, otherwise fall back to find
    local cmd
    if vim.fn.executable("fd") == 1 then
      -- Use fd with --glob and --full-path to match against entire path
      cmd = string.format("cd %s && fd --type f --full-path --glob '%s'", vim.fn.shellescape(search_dir), pattern)
    else
      -- Use find with -path
      cmd = string.format("cd %s && find . -type f -path '%s'", vim.fn.shellescape(search_dir), pattern)
    end

    local matched_files = vim.fn.systemlist(cmd)
    for _, file in ipairs(matched_files) do
      -- Remove leading ./
      file = file:gsub("^%./", "")
      if not seen[file] then
        table.insert(all_files, file)
        seen[file] = true
      end
    end
  end

  return all_files
end

return M
