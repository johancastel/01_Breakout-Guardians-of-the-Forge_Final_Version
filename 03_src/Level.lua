
local Level = {}

Level.__index = Level

function Level:new()

    local self = setmetatable({}, Level)

    return self

end

function Level:update(dt)

end

function Level:draw()

end

return Level