local config = require("shiki.config")
local highlight = require("shiki.highlight")
local node = require("shiki.node")
local M = {}

---@param opts? shiki.Config
M.setup = function(opts)
  opts = vim.tbl_deep_extend("force", config.defaults, opts or {})
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
