local gdebug = require "gears.debug"
local naughty = require "naughty"
local default_opts = require "user.options.defaults"
local has_custom, custom_opts = pcall(require, "user.options.custom")

local options = default_opts

if has_custom then
   options = custom_opts
   setmetatable(options, {
      __index = function(_, key)
         return default_opts[key]
      end,
   })
end

--- Split string with separator/pattern
---@param s string string to split
---@param d string separator/pattern used as delimiter
---@param pattern boolean? wether to search `d` as a pattern or not
local function split(s, d, pattern)
   local res = {}
   local substart = 1
   local pstart, pend = s:find(d, 1, not pattern)

   while pstart do
      res[#res + 1] = s:sub(substart, pstart-1)
      substart = pend+1
      pstart, pend = s:find(d, substart, not pattern)
   end

   res[#res+1] = s:sub(substart)

   return res
end

--- Get options using '.' to access tables
---@param key string
local function getopt(key)
   io.stderr:write("get option: " .. key)
   ---@type any
   local target = options

   for _, c in ipairs(split(key, ".")) do
      target = target[c]
   end

   io.stderr:write(gdebug.dump_return(target, "value"))

   return target
end

--- Show critical notification
---@param title string
---@param text string
local function notify_error(title, text)
   naughty.notify {
      preset = naughty.config.presets.critical,
      title = title,
      text = text,
   }
end

return {
   getopt = getopt,
   notify_error = notify_error,
}
