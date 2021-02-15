local maf = require("lib.maf")
local vector_sequence = require("vector_sequence")

local straight_sequence = {
  _class = "straight_sequence",      
  
  is_valid = function(self)
    local direction_match_counter = maf.vector(0,0) 
    
    local last_vector
    for _, vector in pairs (self.list) do
      if last_vector then
        local increment = maf.vector(((last_vector.x == vector.x) and 1) or 0, ((last_vector.y == vector.y) and 1) or 0)
        direction_match_counter = direction_match_counter + increment
      end
      last_vector = vector
    end
    
    return ((direction_match_counter.x + 1) ==  #self.list) or ((direction_match_counter.y + 1) ==  #self.list)
  end
}

setmetatable(straight_sequence, {
  __index = vector_sequence,
  __call = function(self, list)
      local object = {
          list = {}
      }
      setmetatable(object, {  __index = straight_sequence })    
      object:push(list or {})          
      return object
  end
})

return straight_sequence