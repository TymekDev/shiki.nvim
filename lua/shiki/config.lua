local M = {}

---@type shiki.Config
M.defaults = {
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

return M