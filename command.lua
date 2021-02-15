local lume = require("lib.lume")

command = {
  memory = {},  
  
  clear = function(self)
    self.memory = nil
    self.memory = {}
  end,
  
  get_last = function (self)
    if type(self.memory) == "table" then return self.memory end
    return false
  end,
  
  read  = function(self)
    self:clear()
    for argument in io.read():gmatch("%S+") do 
      table.insert(self.memory, tonumber(argument) or argument)
    end
    return true
  end,

}

return command