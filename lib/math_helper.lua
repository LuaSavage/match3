local math_helper = {
  -- в самом деле sign работает немного иначе, но мне нужно именно это
  sign = function (self,value)
    value = tonumber(value)    
    if not value then return false end

    if math.abs(value) >= 0.5 then
      return value/math.abs(value)
    else
      return 0
    end
    
    return false
  end,
  
  vector_summ = function(...)
    local args = {...}    
    local a, b = unpack(args)
    return a+b    
  end,
  
  is_in_interval = function(...)
    local value, from, to = unpack({...})
    value, from, to = tonumber(value), tonumber(from), tonumber(to)
    return (value >= from) and (value <= to)    
  end,
}

return math_helper

