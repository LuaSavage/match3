local math_helper = require("lib.math_helper")
local maf = require("lib.maf")
local lume = require("lib.lume")

local matrix_filter = require("matrix_filter")

local move_sequence = {
  _class = "move_sequence",
  
  filter = {
    semi_triangle = matrix_filter({
      maf.vector(0,2),
      maf.vector(1,1),
      maf.vector(1,0),     
    }, maf.vector(1,1)),

    semi_rhomboid = matrix_filter({
      maf.vector(0,2),
      maf.vector(1,1),
      maf.vector(2,2),     
    }, maf.vector(1,1))      
  },
  
  find_once = function(self, kernel)
    for _, filter in pairs(self.filter) do
      if filter:match_once(kernel) then return true, kernel:get_center() end
    end    
    return false
  end
}

return move_sequence