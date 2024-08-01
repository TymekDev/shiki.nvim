---@class (exact) shiki.Config
---@field cmd? boolean
---@field highlight? shiki.HighlightConfig
---@field install? shiki.InstallConfig

---@class (exact) shiki.HighlightConfig
---@field shiki? shiki.ShikiSingleConfig|shiki.ShikiDualConfig

---@class (exact) shiki.ShikiSingleConfig
---@field theme string

---@class (exact) shiki.ShikiDualConfig
---@field defaultColor? false
---@field themes { dark: string, light: string }

---@class (exact) shiki.InstallConfig
---@field cmd? string
---@field args? string[]
---@field version? string
---@field rebuild? boolean
