local Accuracy = {
   COUNTRY = 1,
   CITY = 4,
   NEIGHBOURHOOD = 5,
   STREET = 6,
   EXACT = 8,
}

local WHERE_AM_I_BIN = "/usr/lib/geoclue-2.0/demos/where-am-i"
local AWK_GET_LOCATION = "awk 'NR==4 {lat=\\$2} NR==5 {lon=\\$2} END {print lat, lon}'"

local function where_am_i(accuracy, timeout)
   accuracy = accuracy or Accuracy.CITY
   timeout = timeout or 1

   local cmd = ([[sh -c "%s -a %d -t %d | %s"]]):format(WHERE_AM_I_BIN, accuracy, timeout, AWK_GET_LOCATION)
   local output = io.popen(cmd, "r"):read "*l"
   local lat, lon = output:match("([0-9.-]*)° ([0-9.-]*)°")

   return {
      lat = tonumber(lat),
      lon = tonumber(lon)
   }
end

return {
   Accuracy = Accuracy,
   where_am_i = where_am_i
}
