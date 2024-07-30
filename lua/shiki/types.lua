---@class (exact) shiki.Config
---@field cmd? boolean
---@field highlight? shiki.HighlightConfig
---@field install? shiki.InstallConfig
---@field rebuild? boolean

---@alias shiki.HighlightConfig shiki.SingleHighlightConfig|shiki.DualHighlightConfig

---@class (exact) shiki.SingleHighlightConfig
---@field theme string

---@class (exact) shiki.DualHighlightConfig
---@field defaultColor? false
---@field themes { dark: string, light: string }

---@class (exact) shiki.InstallConfig
---@field cmd? string
---@field args? string[]
---@field version? string
