local node = require("shiki.node")
local M = {}

---@type shiki.Options
local defaults = {
  install = {
    cmd = "npm",
    args = { "install", "--save-dev" },
    version = "1.10.3",
  },
  rebuild = false,
}

---@param opts shiki.Options
M.setup = function(opts)
  opts = vim.tbl_deep_extend("force", defaults, opts or {})
  if opts.rebuild == true then
    node.rebuild(opts.install)
  else
    node.init(opts.install)
  end
end

return M
