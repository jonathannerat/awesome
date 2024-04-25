--- Split string with separator/pattern
---@param s string string to split
---@param d string separator/pattern used as delimiter
---@param pattern boolean? wether to search `d` as a pattern or not
---@return string[]
local function split(s, d, pattern)
   local res = {}
   local substart = 1
   local pstart, pend = s:find(d, 1, not pattern)

   while pstart do
      res[#res + 1] = s:sub(substart, pstart - 1)
      substart = pend + 1
      pstart, pend = s:find(d, substart, not pattern)
   end

   res[#res + 1] = s:sub(substart)

   return res
end

return {
   split = split
}
