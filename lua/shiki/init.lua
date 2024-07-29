local highlight = require("shiki.highlight")
local node = require("shiki.node")
local M = {}

---@type shiki.Options
local defaults = {
  cmd = true,
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
  if opts.cmd == true then
    vim.api.nvim_create_user_command(
      "Shiki",
      ---@param tbl { line1: number, line2: number }
      function(tbl)
        local result = highlight.lines(0, { tbl.line1, tbl.line2 })
        vim.fn.setreg("+", vim.split(result, "\n"))
      end,
      {
        desc = "Copy a syntax-highlighted HTML code of a selected text or a provided range (powered by shiki)",
        range = true,
      }
    )
  end
end

return M
