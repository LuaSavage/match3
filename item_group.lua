local item_group = {
      _class = "item_group",
      --name = color,
      --list = {},
      --count = 0,

      empty = function(self) return (#self.list == 0) end,

      extract = function(self)
        if #self.list > 0 then
            local instance = self.list[#self.list]
            table.remove(self.list)
            return instance
        end

        return false
      end,

      add = function(self, instance)
        if type(instance) == "table" then
          table.insert(self.list, instance)
          self.count = self.count + 1
        end

        return false
      end
}

setmetatable(item_group,{
  __call = function(self, name)
      if not name then return nil end

      local object = {
        name = name,
        list = {},
        count = 0,
      }
      setmetatable(object, { __index = item_group })   

      return object
  end
})

return item_group