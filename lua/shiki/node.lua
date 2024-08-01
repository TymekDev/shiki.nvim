local config = require("shiki.config")
local M = {}

---@param ... string
local root = function(...)
  return vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]], "shiki", ...)
end

---@param cfg? shiki.InstallConfig
local install_shiki = function(cfg)
  cfg = vim.tbl_deep_extend("force", config.defaults.install or {}, cfg or {})
  local shiki = "shiki"
  if cfg.version ~= nil then
    shiki = "shiki@" .. cfg.version
  end
  local cmd = vim.iter({ cfg.cmd, cfg.args, shiki }):flatten():totable()
  vim.system(cmd, { cwd = root() }, function(result)
    if result.code ~= 0 then
      error(string.format("shiki.nvim: failed to run '%s':\n%s", table.concat(cmd, " "), result.stderr))
    end
    vim.schedule(function()
      vim.notify(string.format("shiki.nvim: installed %s", shiki), vim.log.levels.INFO)
    end)
  end)
end

---Initalize a shiki.nvim's node directory
---@param cfg? shiki.InstallConfig
M.init = function(cfg)
  if vim.fn.isdirectory(root()) == 1 then
    return
  end
  vim.fn.mkdir(root(), "p")
  vim.fn.writefile({ '{"name":"shiki.nvim","private":true}' }, root("package.json"))
  install_shiki(cfg)
end

---Delete the shiki.nvim's node directory
M.purge = function()
  vim.fn.delete(root(), "rf")
end

---Calls `purge()` followed by `init(config)`
---@param cfg? shiki.InstallConfig
M.rebuild = function(cfg)
  M.purge()
  M.init(cfg)
end

---Exec an inline script within the shiki.nvim's node directory
---Uses `--input-type=module` to enable module imports.
---@param script string
---@return string # stdout from running the script
M.exec = function(script)
  local result = vim.system({ "node", "--input-type", "module", "--eval", script }, { cwd = root() }):wait()
  if result.code ~= 0 then
    error(result.stderr)
  end
  return result.stdout
end

return M
