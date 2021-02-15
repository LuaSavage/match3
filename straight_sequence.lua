local maf = require("lib.maf")

local path_finder = require("path_finder")
local vector_sequence = require("vector_sequence")

local straight_sequence = {
  _class = "straight_sequence",      

  -- выглядит как позор, но времени править это нет
  find_left = function(self, field, position)
    return path_finder:find_directional_sequence(field, position,  maf.vector(0,-1))
  end,

  find_right = function(self, field, position)
    return path_finder:find_directional_sequence(field, position,  maf.vector(0,1))
  end,

  find_top = function(self, field, position)
    return path_finder:find_directional_sequence(field, position, maf.vector(-1,0))
  end,

  find_down = function(self, field, position)
    return path_finder:find_directional_sequence(field, position, maf.vector(1,0))
  end,

  find_vertical = function(self, field, position)
      local path = vector_sequence(self:find_top(field, position))
      path:push(self:find_down(field, position)) 
      return path.list
  end,
  
  find_horizontal = function(self, field, position)
      local path = vector_sequence(self:find_left(field, position))
      path:push(self:find_right(field, position))
      return path.list
  end, 

}

return straight_sequence