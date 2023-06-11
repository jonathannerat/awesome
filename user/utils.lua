local options = require "user.defaults"
local has_custom, custom_opts = pcall(function()
   return require "user.custom"
end)

if has_custom then
   options = custom_opts
end

local function custom(key)
   return options[key]
end

return {
   custom = custom,
}
