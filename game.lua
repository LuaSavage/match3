local maf = require("lib.maf")

local field = require("field")
local move = require("move")
require("command")

local game = {

	field = field,

	on_command_quit = function(self, cmd) os.exit() end,
	on_command_move = function(self, cmd, x, y, dir)
		x, y = tonumber(x), tonumber(y)
		local valid_dir = {
			["l"] = maf.vector(0,-1), 
			["r"] = maf.vector(0, 1), 
			["u"] = maf.vector(-1,0), 
			["d"] = maf.vector(1,0)
		}
		if not x or not y or not valid_dir[dir] then return end

		local from = maf.vector(x,y)
		local to = from + valid_dir[dir]
		self.field:move(from,to) 
	end,

	init = function(self) self.field:init() end,

	tick = function(self)
		--[[
			вообще говоря назначение обработчиков команд и последующий их вызов 
			можно реализовать средствами класса command, однако это лишит от части смысла tick
		]]

		local cmd = command:get_last()

		local handlers = {
			["q"] = self.on_command_quit, 
			["m"] = self.on_command_move
		}

		for command, handler in pairs(handlers) do	
			if cmd[1] == command then handler(self, unpack(cmd)) end	 
		end

		if not move:find_once(self.field) then self.field:mix() end
	end,

	--on_change = function(self)self:dump() end,  
  
	dump = function(self)
	    local row = "   "
	    
	    for i = 0, self.field.size-1 do row = string.format(row.."%u ", i) end
	    print(row)
	    print(string.format("  %s", string.rep(" -",self.field.size)))
	   
	    for i = 1, self.field.size do
	      local row = string.format("%s | ", (i-1))

	      for j = 1, self.field.size do
	        local current_crystal = ((self.field.matrix[i] or {})[j]) or {}
	        row = row..(current_crystal.color or " ").." "
	      end  
	      print(row)
	    end
	end
}

setmetatable(game.field.slot, { __index = { parent = game.field  } })
setmetatable(game.field, { __index = { parent = game  } })

return game