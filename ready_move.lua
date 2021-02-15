local vector_sequence = require("vector_sequence")
local straight_sequence = require("straight_sequence")

local ready_move = {
    _class = "ready_move",    
    min_len = 3,

    is_long_enough = function(self, path)
      if type(path) ~= "table" then return false end
      return (#path >= self.min_len)
    end,

    find = function(self, field, point)
      local vertical, horizontal = self:find_vertical(field, point), self:find_horizontal(field, point)
      if (not vertical) and (not horizontal) then return false end
      -- объединение на редкий случай вертикальной и горизонтальной тройки
      local path = vector_sequence(vertical or {})
      path:push(horizontal or {}) 
      return path.list
    end,

    -- выглядит как позор, но времени править это нет
    find_left = function(self, field, position)
      local path = straight_sequence:find_left(field, position) or {}
      return (self:is_long_enough(path) and path) or false
    end,

    find_right = function(self, field, position)
      local path = straight_sequence:find_right(field, position) or {}
      return (self:is_long_enough(path) and path) or false
    end,

    find_top = function(self, field, position)
      local path = straight_sequence:find_top(field, position) or {}
      return (self:is_long_enough(path) and path) or false
    end,

    find_down = function(self, field, position)
      local path = straight_sequence:find_down(field, position) or {}
      return (self:is_long_enough(path) and path) or false
    end,

    find_vertical = function(self, field, position)
      local path = straight_sequence:find_vertical(field, position) or {}
      return (self:is_long_enough(path) and path) or false
    end,
  
    find_horizontal = function(self, field, position)
        local path = straight_sequence:find_horizontal(field, position) or {}
        return (self:is_long_enough(path) and path) or false
    end,
  }

  return ready_move