local config = require("shiki.config")
local node = require("shiki.node")
local M = {}

---@param code string
---@param lang string
---@param cfg? shiki.HighlightConfig
---@return string
local script = function(code, lang, cfg)
  cfg = vim.tbl_deep_extend("force", config.defaults.highlight, cfg or {})
  local cfg_json = string.gsub(vim.json.encode(cfg), '"', '\\"')
  code = string.gsub(code, "\n", "\\n")
  code = string.gsub(code, '"', '\\"')
  return string.format(
    [[import { codeToHtml } from "shiki";

const result = await codeToHtml("%s", {
  lang: "%s",
  ...JSON.parse("%s"),
});

console.log(result);]],
    code,
    lang,
    cfg_json
  )
end

---@param code string|string[]
---@param lang string
---@param cfg? shiki.HighlightConfig
---@return string # An HTML code with a highlighted syntax
M.code = function(code, lang, cfg)
  if type(code) == "table" then
    code = table.concat(code, "\n")
  end
  local result = node.exec(script(code, lang, cfg))
  result = string.gsub(result, "\n$", "")
  return result
end

---@param bufnr integer
---@param lines number|[number, number]
---@param lang? string If not provided or `nil`, then a `bufnr` buffer's filetype is used
---@param cfg? shiki.HighlightConfig
---@return string # An HTML code with a highlighted syntax
M.lines = function(bufnr, lines, lang, cfg)
  lang = lang or vim.bo[bufnr].filetype
  if type(lines) == "number" then
    lines = { lines, lines }
  end
  local code = vim.api.nvim_buf_get_lines(bufnr, lines[1] - 1, lines[2], true)
  -- NOTE: this might break. There might exist filetypes that are not what the "lang" option expects.
  return M.code(code, lang, cfg)
end

return M
