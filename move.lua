local maf = require("lib.maf")

local move_sequence = require("move_sequence")
local filter_kernel = require("filter_kernel")
local path_finder = require("path_finder")

local move = {  
  
  find_once = function(self, field)
    center = center or maf.vector(0,0)
    
    for i = center.x, field.size do
      for j = center.y, field.size do
        local frame_center = maf.vector(i,j)
        local item = field.slot:get_content(frame_center)
        if item then
          local neighbors_list = path_finder:find_neighbors_position(field, frame_center)
          if move_sequence:find_once(filter_kernel(neighbors_list, frame_center)) then 
            return true 
          end
        end
      end  
    end
    
    return false
  end
 
}

return move