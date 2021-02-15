local maf = require("lib.maf")
local math_helper = require("lib.math_helper")
local lume = require("lib.lume")
local vector_sequence = require("vector_sequence")

local filter_kernel = {
  _class = "filter_kernel",
  
  fallback = function(self)
    self.list = lume.clone(self._original_list)
    self._center = self._original_center
  end,
  
  set_center = function(self, center)
    center = center or {}
    if not center.x or not center.y then return end
    self._center = center
  end,

  get_center = function(self) return self._center end,
  
  displace = function(self, bias)
    bias = bias or {}
    if not bias.x or not bias.y then return end
    
    self:displace_center(bias)
    
    for index, component in pairs (self.list) do
      self.list[index] = component + bias
    end
  end,
  
  displace_center = function(self, bias)
    bias = bias or {}
    if not bias.x or not bias.y then return end    
    self:set_center(self:get_center() + bias)
  end,
  
  displace_to_point = function(self, point)
    point = point or {}
    if not point.x or not point.y then return end
    
    local center = self:get_center()
    self:displace(point - center)
  end,

  -- угол в радианах
  rotate = function(self, angle)
    local center = self:get_center()
    
    for index, component in pairs (self.list) do
      local x = center.x + (component.x-center.x)*math.cos(angle) - (component.y-center.y)*math.sin(angle)
      local y = center.y + (component.y-center.y)*math.cos(angle) + (component.x-center.x)*math.sin(angle)
      self.list[index] = maf.vector(x,y)
    end
  end,
  
}

setmetatable(filter_kernel,{
  __index = vector_sequence,
  __call = function(self, list, center)
      local object = {  
        list = {} 
      }
      setmetatable(object, { __index = filter_kernel })    
      object:push(list or {})  
      object._original_list = lume.clone(object.list)
      
      object:set_center(center)     
      object._original_center = center  
      return object
  end
})

return filter_kernel