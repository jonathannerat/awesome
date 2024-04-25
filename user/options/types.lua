---@meta

---@class IconOptions
---@field theme string?
---@field path string[]?
local iconopts = {}

---@class NotificationOptions
---@field icon_size number?
---@field width number?
---@field max_width number?
---@field font string?
local notifopts = {}

---@class WibarOptions
---@field height number?
---@field position "top"|"bottom"|"left"|"right"?
local wibaropts = {}

---@class TagsOptions
---@field names table<string, string>?
---@field in_order string[]?
local uiopts = {}

---@class UIOptions
---@field useless_gap number?
local uiopts = {}

---@class Options
---@field font string?
---@field theme string?
---@field icon IconOptions?
---@field notification NotificationOptions?
---@field wibar WibarOptions?
---@field tags TagsOptions?
---@field ui UIOptions?
local opts = {}
