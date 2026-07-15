-- strongbrick.lua · POLIMORFISMO: aguanta 2 golpes
local Brick = require("03_src/Brick")
local StrongBrick = setmetatable({}, { __index = Brick })
StrongBrick.__index = StrongBrick

function StrongBrick.new(x, y)
    local self = Brick.new(x, y)
    self._hp = 2
    self.type = "strong"
    return setmetatable(self, StrongBrick)
end

function StrongBrick:onHit() 
    self._hp = self._hp - 1
    if self._hp <= 0 then 
        self._dead = true 
    end
    return 20
end

function StrongBrick:draw()
    if self._dead then return end
    -- Color naranja/amarillo para diferenciarlo
    if self._hp == 2 then
        love.graphics.setColor(0.9, 0.6, 0.15) -- Ladrillo fuerte intacto
    else
        love.graphics.setColor(0.7, 0.45, 0.1) -- Agrietado/dañado
    end
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    
    -- Dibujar borde
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end

return StrongBrick
