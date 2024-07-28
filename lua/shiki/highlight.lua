local node = require("shiki.node")
local M = {}

---@param code string
---@param lang string
---@return string
local script = function(code, lang)
  code = string.gsub(code, "\n", "\\n")
  code = string.gsub(code, '"', '\\"')
  return string.format(
    [[import { codeToHtml } from "shiki";

const result = await codeToHtml("%s", {
  lang: "%s",
  themes: {
    light: "github-light",
    dark: "github-dark",
  },
  defaultColor: false,
});

console.log(result);]],
    code,
    lang
  )
end

---@param code string|string[]
---@param lang string
---@return string # An HTML code with a highlighted syntax
M.code = function(code, lang)
  if type(code) == "table" then
    code = table.concat(code, "\n")
  end
  local result = node.exec(script(code, lang))
  result = string.gsub(result, "\n$", "")
  return result
end

---@param bufnr integer
---@param lines number|[number, number]
---@return string # An HTML code with a highlighted syntax
M.lines = function(bufnr, lines)
  if type(lines) == "number" then
    lines = { lines, lines }
  end
  local code = vim.api.nvim_buf_get_lines(bufnr, lines[1] - 1, lines[2], true)
  -- NOTE: this might break. There might exist filetypes that are not what the "lang" option expects.
  return M.code(code, vim.bo[bufnr].filetype)
end

return M
