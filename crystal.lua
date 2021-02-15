local class_crystal = {
  _class = "crystal",
  allowed_colors = {A = true, B = true, C = true, D = true, E = true, F = true},
  
  set_color = function(self, color) 
    color = string.upper(tostring(color))
    self.color = (self.allowed_colors[color] and color) or "A"
  end,
  
  set_random_color = function(self, color)
    -- пока так, потом вынесу в цветовую схему
    local color_list = {}
    for value, _ in pairs(self.allowed_colors) do table.insert(color_list, value) end      
    self:set_color(color_list[math.random(1,#color_list)])
  end
}

setmetatable(class_crystal, {
  __call = function(self, properties)
      properties = properties or {}
    
      local object = {}
      setmetatable(object, {
          __index = class_crystal
      })
    
      object:set_color(properties.color)
          
      return object
  end
})

return class_crystal