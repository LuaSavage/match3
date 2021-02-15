local game = require("game")
require("command")

game:init()
game:dump()

while true do
  command:read()
  game:tick()
  game:dump()
end
