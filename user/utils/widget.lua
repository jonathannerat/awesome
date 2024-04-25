local shape = require "gears.shape"

local function rounded(radius)
   return function(cr, w, h)
      return shape.rounded_rect(cr, w, h, radius)
   end
end

return {
   rounded_corners = rounded,
}
