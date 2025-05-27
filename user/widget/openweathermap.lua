local button = require "awful.button"
local spawn = require "awful.spawn"
local tooltip = require "awful.tooltip"
local dkjson = require "dkjson"
local gtable = require "gears.table"
local gtimer = require "gears.timer"
local naughty = require "naughty"
local textbox = require "wibox.widget.textbox"

local options = require "user.options"
local MouseButton = require("user.constants").MouseButton

local Accuracy = {
   COUNTRY = 1,
   CITY = 4,
   NEIGHBORHOOD = 5,
   STREET = 6,
   EXACT = 8,
}

local API_KEY = options "env.OPENWEATHERMAP_API_KEY"
local ERROR_TEXT = " Weather n/a"
local ICONS = {
   ["11d"] = " ",
   ["11n"] = " ",
   ["09d"] = " ",
   ["09n"] = " ",
   ["10d"] = " ",
   ["10n"] = " ",
   ["13d"] = " ",
   ["13n"] = " ",
   ["50d"] = " ",
   ["50n"] = " ",
   ["01d"] = " ",
   ["01n"] = " ",
   ["02d"] = " ",
   ["02n"] = " ",
   ["03d"] = " ",
   ["03n"] = " ",
   ["04d"] = " ",
   ["04n"] = " ",
}

---@class WeatherJson {{{
---@field coord {lon: number, lat: number}
---@field weather {id: integer, main: string, description: string, icon: string}[]
---@field base string
---@field main table
---@field main.temp number
---@field main.feels_like number
---@field main.temp_min number
---@field main.temp_max number
---@field main.pressure number
---@field main.humidity number
---@field main.sea_level number
---@field main.grnd_level number
---@field visibility integer
---@field wind { speed: number, deg: integer, gust: number }
---@field rain { ["1h"]: number?, ["3h"]: number?}
---@field show { ["1h"]: number?, ["3h"]: number?}
---@field clouds { all: integer }
---@field dt integer
---@field sys { type: integer, id: integer, country: string, sunrise: integer, sunset: integer }
---@field timezone integer
---@field id integer
---@field name string
---@field cod integer }}}
local WeatherJson = {}

local WeatherWidget = { mt = {} }

function WeatherWidget:new(o)
   o = o or {}
   self.__index = self
   setmetatable(o, self)
   o:init()
   return o
end

function WeatherWidget:init()
   self.timeout = self.timeout or (1 * 60 * 60)
   ---@type {weather_json: WeatherJson, updated_at: osdate}
   self.data = {}
   self.in_error = false

   local w = textbox(self.initial_text)
   local t = gtimer { timeout = self.timeout }
   self.widget = w
   self.timer = t

   t:connect_signal("timeout", function()
      t:stop()
      self:update()
   end)
   t:start()
   t:emit_signal "timeout"

   w:buttons(gtable.join(
      button({}, MouseButton.LEFT, function() end),
      button({}, MouseButton.RIGHT, function()
         w:set_text(self.initial_text)
         self:update()
      end)
   ))

   tooltip {
      objects = {w},
      timer_function = function ()
         return self.data.updated_at
      end
   }
end

function WeatherWidget:update()
   self:fetch_coordinates(function(lat, long)
      self:fetch_weather(lat, long, function()
         self.widget:set_text(self:get_weather_text())
         self.timer:again()
      end)
   end)
end

function WeatherWidget:get_weather_text()
   local json = self.data.weather_json
   local icon = ICONS[json.weather[1].icon]
   local temp = json.main.temp
   local feels_like = json.main.feels_like
   local text = ("%s%.1f°C"):format(icon, temp)

   if math.abs(temp - feels_like) >= 1 then
      text = text .. (" (%.1f°C)"):format(feels_like)
   end

   return text
end

function WeatherWidget:reset_error()
   if self.in_error then
      self.in_error = false
      self:set_timeout(self.timeout)
   end
end

function WeatherWidget:handle_error()
   if self.in_error then
      self:double_timeout()
   else
      self:set_timeout(60)
      self.in_error = true
   end

   naughty.notify {
      title = "Weather",
      text = "Failed to fetch weather. Retrying in " .. tostring(self.timer.timeout) .. " seconds…",
      preset = naughty.config.presets.warn,
      icon = "weather",
   }

   self.widget:set_text(ERROR_TEXT)
   self.timer:again()
end

function WeatherWidget:set_timeout(t)
   self.timer.timeout = t
end

function WeatherWidget:get_timeout()
   return self.timer.timeout
end

function WeatherWidget:double_timeout()
   self:set_timeout(self:get_timeout() * 2)
end

function WeatherWidget:fetch_coordinates(callback)
   local geoclue_cmd = ("/usr/lib/geoclue-2.0/demos/where-am-i -a %d -t %d"):format(Accuracy.NEIGHBORHOOD, 10)

   spawn.easy_async(geoclue_cmd, function(stdout, _, _, exitcode)
      ---@cast stdout string
      ---@cast exitcode integer
      if exitcode ~= 0 then
         self:handle_error()
         return
      end

      local lat, long

      for name, value in stdout:gmatch "(%w+):%s*([-+]%d+%.%d+)°" do
         if name == "Latitude" then
            lat = tonumber(value)
         elseif name == "Longitude" then
            long = tonumber(value)
         end
      end

      if lat and long then
         self:reset_error()
         callback(lat, long)
      else
         self:handle_error()
      end
   end)
end

function WeatherWidget:fetch_weather(lat, long, callback)
   local weather_cmd = ("curl 'https://api.openweathermap.org/data/2.5/weather?units=metric&lat=%.2f&lon=%.2f&appid=%s'"):format(
      lat,
      long,
      API_KEY
   )
   spawn.easy_async(weather_cmd, function(stdout, _, _, exitcode)
      if exitcode ~= 0 then
         self:handle_error()
         return
      end

      ---@type WeatherJson
      local weather_json = dkjson.decode(stdout)

      self:reset_error()
      self.data.weather_json = weather_json
      self.data.updated_at = os.date("Last updated at %H:%M")
      callback()
   end)
end

function WeatherWidget.mt.__call(_, ...)
   return WeatherWidget:new(...).widget
end

return setmetatable(WeatherWidget, WeatherWidget.mt)
