local Brick = {}

Brick.__index = Brick

function Brick:new()

    local self = setmetatable({}, Brick)

    return self

end

function Brick:update(dt)

end

function Brick:draw()

end

return Brick