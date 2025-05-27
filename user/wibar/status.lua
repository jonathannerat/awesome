local option = require "user.options"

local fixed = require "wibox.layout.fixed"
local separator = require "wibox.widget.separator"
local gtable = require "gears.table"

return gtable.crush(option "ui.status", {
   layout = fixed.horizontal,
   spacing = 15,
   spacing_widget = separator,
})
