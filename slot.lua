local maf = require("lib.maf")

local slot = {
		_class = "slot",
    	
    	is_in_bounds = function(self, point)
    		if type(point) ~= "table" then return false end
    		if (point.x < 1) or (point.x > self.parent.size) then return false end
     		if (point.y < 1) or (point.y > self.parent.size) then return false end 
     		return true  		
    	end,

	    get_content = function(self, point)
	        if type(point) ~= "table" then return end

	        local content = (self.parent.matrix[point.x] or {})[point.y]
	        if (content or {})._class then return content end
	        return false        
	    end,

	    set_content = function(self, position, content)
	        if type(position) ~= "table" then return end
	        if self:is_in_bounds(position) then
	        	self.parent.matrix[position.x][position.y] = content
	        	return true
	        end
	        return false        
	    end,

	    remove_content = function(self, vector_seq)
	    	if type(vector_seq) ~= "table" then return end
	    	for _, point in pairs(vector_seq) do
	    		if self:get_content(point) then
	    			self.parent.matrix[point.x][point.y] = nil	
	    		end
	    	end

	    	self.parent:on_slot_remove(vector_seq)
	    end,	    

	    swap = function(self, point1, point2) 
	    	if not self:is_in_bounds(point1) or not self:is_in_bounds(point2) then return false end
	    	self.parent.matrix[point1.x][point1.y], self.parent.matrix[point2.x][point2.y] = self.parent.matrix[point2.x][point2.y], self.parent.matrix[point1.x][point1.y]
	  		return true
	  	end,

	  	fall = function(self, point) 
	  		if type(point) ~= "table" then return false end
	  		local lower_point = point + maf.vector(1,0)	
		    if self:get_content(point) and (not self:get_content(lower_point)) then
  			    if self:swap(point,lower_point) then self:fall(lower_point) end  
  			    self:fall(point + maf.vector(-1,0))
		    end
		end
}

return slot

