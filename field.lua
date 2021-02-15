local maf = require("lib.maf")

local slot = require("slot")
local field_dump = require("field_dump")
local ready_move = require("ready_move")
local vector_sequence = require("vector_sequence")
local crystal = require("crystal")

local field = {
	_class = "field",
    matrix = {},
    size = 10,
 
    slot = slot,
    
    clear = function(self)
      self.matrix = nil
      self.matrix = {}      
      for i = 1, self.size do self.matrix[i] = {} end     
    end,
    
    init = function(self)
      self:clear()
      self:fill()     
    end,

    fill = function(self, option)
    	local unique = (option or {}).unique or false

		for i = 1, self.size do
		    for j = 1, self.size do
		    	local point = maf.vector(i,j)
		    	if not self.slot:get_content(point) then
			        local crystal = crystal()			        
			        crystal:set_random_color()
			        self.slot:set_content(point, crystal)
			        if unique then
			        	repeat crystal:set_random_color()
			        	until not ready_move:find(self,point)
			        end	    			        
		    	end
		 	end
		end 
	end,

	on_slot_remove = function(self)
		--self.parent:on_change()
		self:start_failing()
	end,

	on_failing_stop = function(self)
		--self.parent:on_change() 
		self:fill({unique=true})
	end,

	start_failing = function(self)
		for i = 1, self.size do 
			for j = 1, self.size do	self.slot:fall(maf.vector(i,j)) end 
		end
		self:on_failing_stop()
	end,

	move = function(self, from, to)
		if (type(from) ~= "table") or (type(to) ~= "table") then return false end

 		if self.slot:swap(from, to) then
			local move1, move2 = ready_move:find(self, to), ready_move:find(self, from) 

			if move1 or move2 then
				local move_seq = vector_sequence(move1 or {})
				move_seq:push(move2 or {})
				self.slot:remove_content(move_seq.list)
			else 
				self.slot:swap(from, to)	
			end	  
		end 
	end,

	-- "лобовое" решение, но рабочее
	mix = function(self)
		local dump = field_dump(self)
		self:clear()

		for i = 1, self.size do
		    for j = 1, self.size do
		    	local point = maf.vector(i,j)

 				local left, top = point + maf.vector(0,-1), point + maf.vector(-1,0)
 				local mask = {
 					[(self.slot:get_content(left) or {}).color or false] = true,
 					[(self.slot:get_content(top) or {}).color or false] = true
 				}   		

 				local extracted = dump:get_less_probable(mask)

 				if extracted then
 					self.slot:set_content(point, extracted)
 				else
	 				self.slot:set_content(point, dump:get_less_probable())
	 				if ready_move:find(self,point) then
	 					for k = 1, self.size do
		   					 for x = 1, self.size do
		   					 	local previous_point = maf.vector(k,x)
		   					 	self.slot:swap(point, previous_point)
		   					 	if ready_move:find(self,point) or ready_move:find(self,previous_point) then
		   					 		self.slot:swap(point, previous_point)
		   					 	else break	
		   					 	end
		   					 end
		   				end
	 				end
 				end
		 	end
		end 		
	end	 
  }

  return field