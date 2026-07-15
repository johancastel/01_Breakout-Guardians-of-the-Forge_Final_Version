local Brick = {}
Brick.__index = Brick

function Brick.new(x, y)
    local self = setmetatable({
        x = x,
        y = y,
        w = 52,
        h = 20,
        _dead = false,
        containsPower = (love.math.random(1, 6) == 1)
    }, Brick)
    return self
end

function Brick:onHit()
    self._dead = true
    return 10 
end

function Brick:draw()
    if self._dead then return end
    love.graphics.setColor(0.85, 0.3, 0.3) 
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return Brick