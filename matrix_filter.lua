local maf = require("lib.maf")
local lume = require("lib.lume")
local filter_kernel = require("filter_kernel")

local matrix_filter = {
  _class = "matrix_filter",  

  match_once = function(self, kernel)
    if kernel._class ~= "filter_kernel" then return false end
    
    self:fallback()
    self:displace_to_point(kernel:get_center())
        
    for i = 1, 4 do
      if kernel:is_list_match(self.list) then return true end      
      self:rotate(math.pi/2)
    end

    return false
  end,
  
  --match = function(self) end
}

setmetatable(matrix_filter,{
  __index = filter_kernel,
  __call = function(self, list, center)
      local object = {
          list = {}
      }
      setmetatable(object, { __index = matrix_filter })    
      object:push(list or {})  
      object._original_list = lume.clone(object.list)
      
      object:set_center(center)     
      object._original_center = center  
      return object
  end
})

return matrix_filter