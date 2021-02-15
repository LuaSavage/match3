local maf = require("lib.maf")
local math_helper = require("lib.math_helper")

local path_finder = {
  
  find_neighbors_position = function (self, field, center, color)
    if type(center) ~= "table" then return end
    
    color = (field.slot:get_content(center) or {}).color or color
    if not color then return end
    
    local neighbor = {
      list = {}
    }   
    
    local start, stop = maf.vector(), maf.vector()
    start = center + maf.vector(-1,-1)
    stop = center + maf.vector(1,1)
    
    for i = start.x, stop.x do
      for j = start.y, stop.y do
        neighbor.position = maf.vector(i,j)
        neighbor.instance = field.slot:get_content(neighbor.position)
        if neighbor.instance then
          if neighbor.instance.color == color then
            table.insert(neighbor.list, maf.vector(neighbor.position:unpack()))
          end
        end     
      end  
    end   
    
    return neighbor.list, center    
  end,

  -- также можно искать пустые последовательности
  find_directional_sequence = function(self, field, last, bias, path)
    if (type(last) ~= "table") or ( type(bias) ~= "table") then return false end
    
    local color = (field.slot:get_content(last) or {}).color 
    path = ((type(path) ~= "table") and {last}) or path
        
    local next_position  = last + bias

    if field.slot:is_in_bounds(next_position) then
      if (field.slot:get_content(next_position) or {}).color == color then
        table.insert(path, next_position)
        return self:find_directional_sequence(field, next_position, bias, path)
      end
    end
    
    return path
  end

}

return path_finder