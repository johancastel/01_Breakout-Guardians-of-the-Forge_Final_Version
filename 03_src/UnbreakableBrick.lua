-- unbreakablebrick.lua · POLIMORFISMO: indestructible
local Brick = require("03_src/Brick")
local UnbreakableBrick = setmetatable({}, { __index = Brick })
UnbreakableBrick.__index = UnbreakableBrick

function UnbreakableBrick.new(x, y)
    local self = Brick.new(x, y)
    self._hp = 9999 -- Virtualmente infinito
    self.type = "unbreakable"
    self.containsPower = false -- No puede soltar poderes
    return setmetatable(self, UnbreakableBrick)
end

function UnbreakableBrick:onHit()
    -- No se muere, no otorga puntos
    return 0
end

function UnbreakableBrick:draw()
    if self._dead then return end
    -- Color gris metalico
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    
    -- Dibujar borde y adorno de metal
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.rectangle("line", self.x + 4, self.y + 4, self.w - 8, self.h - 8)
end

return UnbreakableBrick
