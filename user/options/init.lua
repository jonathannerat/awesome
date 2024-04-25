local split = require("user.utils").split
local default_opts = require "user.options.defaults"
local has_custom, custom_opts = pcall(require, "user.options.custom")

--- Get option from table
---@param options table<string, any>
---@param keys string[]
local function get(options, keys)
   local i = 1

   while type(options) == "table" and i <= #keys do
      options = options[keys[i]]
      i = i + 1
   end

   return options
end

return function(key)
   local keys = split(key, ".")
   local option = get(default_opts, keys)

   if has_custom then
      option = get(custom_opts, keys) or option
   end

   return option
end
