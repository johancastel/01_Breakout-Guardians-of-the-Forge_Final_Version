local Game = {}

Game.__index = Game

function Game:new()

    local self = setmetatable({}, Game)

    return self

end

function Game:update(dt)

end

function Game:draw()

end

return Game