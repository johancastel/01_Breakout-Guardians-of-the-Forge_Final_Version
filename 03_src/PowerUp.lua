local PowerUp = {}
PowerUp.__index = PowerUp

function PowerUp.new(x, y, efecto, letter, color, label)
    local self = setmetatable({
        x = x,
        y = y,
        w = 16,
        h = 16,
        vy = 120,
        efecto = efecto,
        letter = letter or "P",
        color = color or {0.2, 0.8, 0.2},
        label = label or "",
        isActive = true
    }, PowerUp)
    return self
end

function PowerUp:update(dt)
    self.y = self.y + self.vy * dt
end

function PowerUp:draw()
    -- Dibujar cápsula coloreada con su respectiva letra identificadora
    love.graphics.setColor(self.color[1], self.color[2], self.color[3])
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, 4, 4)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(10))
    love.graphics.print(self.letter, self.x + (self.w - love.graphics.getFont():getWidth(self.letter))/2, self.y + 2)
    
    -- Dibujar texto en español arriba de la cápsula centrado
    if self.label and self.label ~= "" then
        love.graphics.setFont(love.graphics.newFont(9))
        -- Sombra negra para legibilidad sobre el fondo
        love.graphics.setColor(0, 0, 0, 0.9)
        love.graphics.printf(self.label, self.x - 40, self.y - 12, 96, "center")
        -- Texto coloreado con el color del poder
        love.graphics.setColor(self.color[1], self.color[2], self.color[3])
        love.graphics.printf(self.label, self.x - 40, self.y - 13, 96, "center")
    end
end

function PowerUp:spawn()
end

function PowerUp:apply(target)
end

function PowerUp:remove(target)
end

return PowerUp