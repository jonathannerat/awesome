local textclock = require "wibox.widget.textclock"
local awful = require "awful"
local calendar = require "awful.widget.calendar_popup"
local gtable = require "gears.table"

local cycleclock = { mt = {} }

function cycleclock:get_current_format()
   return self._private.formats[self._private.current_index + 1]
end

function cycleclock:cycle_next_format()
   local next_index = (self._private.current_index + 1) % #self._private.formats

   self._private.current_index = next_index

   return self:get_current_format()
end

local function new(formats, refresh, tzid)
   local w = textclock(formats[1], refresh, tzid)
   gtable.crush(w, cycleclock, true)

   w._private.formats = formats
   w._private.current_index = 0

   local month_calendar = calendar.month { position = "tr" }
   local year_calendar = calendar.year { position = "cc" }

   w:buttons(gtable.join(
      awful.button({}, 1, function()
         w:set_format(w:cycle_next_format())
      end),
      awful.button({}, 2, function()
         month_calendar:toggle()
      end),
      awful.button({}, 3, function()
         year_calendar:toggle()
      end)
   ))

   return w
end

function cycleclock.mt:__call(...)
   return new(...)
end

return setmetatable(cycleclock, cycleclock.mt)
