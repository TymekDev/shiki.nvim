local highlight = require("shiki.highlight")
local node = require("shiki.node")
local M = {}

---@type shiki.Options
local defaults = {
  -- Create Shiki command?
  cmd = true,
  install = {
    -- Node package manager to install with
    cmd = "npm",
    -- Addtional arguments to the package manager
    args = { "install", "--save-dev" },
    -- Shiki version
    version = "1.10.3",
  },
  -- Remove and reinitialize a shiki.nvim's internal directory?
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

---List supported lanuages
---@return string[]
M.langs = function()
  local langs_json = node.exec([[import { bundledLanguages } from "shiki/langs";
console.log(JSON.stringify(Object.keys(bundledLanguages)));]])
  return vim.json.decode(langs_json)
end

---List supported themes
---@return string[]
M.themes = function()
  local themes_json = node.exec([[import { bundledThemes } from "shiki/themes";
console.log(JSON.stringify(Object.keys(bundledThemes)));]])
  return vim.json.decode(themes_json)
end

return M
