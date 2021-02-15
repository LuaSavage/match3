local lume = require("lib.lume")
local item_group = require("item_group")


local field_dump = {
  _class = "field_dump",
  --instances = {},

  create_color_group = function(self, color)
    if not color then return end
    if self:get_color_group(color) then return end
    local color_group = item_group(color)
    table.insert(self.instances, color_group)
    return color_group
  end,

  get_color_group = function (self, color)
    for _, group in pairs(self.instances) do
      if (group or {}).name == color then return group end  
    end
    
    return false
  end,

  add_instance = function(self, instance)
    if type(instance) ~= "table" then return end

    local color_group = self:get_color_group(instance.color)
    if not color_group then color_group = self:create_color_group(instance.color) end  
    return color_group:add(instance)
  end,  

  get_by_probability = function(self, probability, mask) 
    mask = mask or {}
    local prob = {
      ["min"] = {from = 1, to = #self.instances, increment = 1},
      ["max"] = {from = #self.instances, to = 1, increment = -1},
    }

    local param = prob[probability]
    if not param then return nil end

    self.instances = lume.sort(self.instances, "count")

    for i = param.from, param.to, param.increment do
      local group = self.instances[i]
      if (not mask[group.name]) and (not group:empty()) then return group:extract() end
    end

    return false
  end,

  get_most_probable = function(self, mask) return self:get_by_probability("max", mask) end,
  get_less_probable = function(self, mask) return self:get_by_probability("min", mask) end

}

setmetatable(field_dump,{
  __index = field_dump,
  __call = function(self, field)
      local object = {instances = {}}
      setmetatable(object, { __index = field_dump })   

      for _, row in pairs(field.matrix) do
        for _, instance in pairs(row) do
          if type(instance) == "table" then object:add_instance(instance) end
        end
      end

      return object
  end
})

return field_dump