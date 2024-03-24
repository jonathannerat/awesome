---@meta

---@class IconOptions
---@field theme string
---@field path string[]
local iconopts = {}

---@class NotificationOptions
---@field icon_size number
---@field width number
---@field max_width number
---@field font string
local notifopts = {}

---@class WibarOptions
---@field height number
---@field position "top"|"bottom"|"left"|"right"
---@field useless_gap number
local wibaropts = {}

---@class Options
---@field font string
---@field theme string
---@field icon IconOptions
---@field notification NotificationOptions
---@field wibar WibarOptions
---@field tag_order string[]
local opts = {}
