local config = require("shiki.config")
local highlight = require("shiki.highlight")
local node = require("shiki.node")
local M = {}

---@param cfg? shiki.Config
M.setup = function(cfg)
  cfg = vim.tbl_deep_extend("force", config.defaults, cfg or {})
  if cfg.rebuild == true then
    node.rebuild(cfg.install)
  else
    node.init(cfg.install)
  end
  if cfg.cmd == true then
    vim.api.nvim_create_user_command(
      "Shiki",
      ---@param tbl { line1: number, line2: number }
      function(tbl)
        local result = highlight.lines(0, { tbl.line1, tbl.line2 }, cfg.highlight)
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
