local vector_sequence = {
  _class = "vector_sequence",
  
  is_in = function(self, vector)
    vector = vector or {}

    for _, value in pairs(self.list) do
      if (value.x == (vector.x or 0)) and (value.y == (vector.y or 0)) then return true end
    end
    
    return false
  end,
  
  is_list_match = function(self, list)
    for _, value in pairs(list ) do
      if not self:is_in(value) then return false end      
    end    
    
    return true    
  end,
  
  add = function(self, vector)
    if not self:is_in(vector) then
      return table.insert(self.list, vector)
    end
    
    return false
  end,
  
  push = function(self, list)
    if type(list) ~= "table" then return false end
    for _, value in pairs(list) do self:add(value) end
  end,
  
}

setmetatable(vector_sequence, {
  __call = function(self, list)
      list = list or {}
    
      local object = {
        list = {}
      }
      setmetatable(object, {  __index = vector_sequence })    
      object:push(list)          
      return object
  end
})

return vector_sequence