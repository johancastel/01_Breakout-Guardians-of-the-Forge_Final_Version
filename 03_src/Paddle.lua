local Paddle = {}

Paddle.__index = Paddle

function Paddle:new()

    local self = setmetatable({}, Paddle)

    return self

end

function Paddle:update(dt)

end

function Paddle:draw()

end

return Paddle