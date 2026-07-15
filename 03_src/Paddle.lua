local Paddle = {}
Paddle.__index = Paddle

function Paddle.new()
    local self = setmetatable({
        x = 350,
        y = 550,
        w = 100,
        h = 20,
        width = 100,  -- Alias para compatibilidad UML
        height = 20,  -- Alias para compatibilidad UML
        speed = 500,
        invertedControls = false, -- Flag para invertir controles
        currentPower = "none"
    }, Paddle)
    return self
end

function Paddle:update(dt)
    -- Controles del jugador
    local moveDir = 0
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        moveDir = -1
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        moveDir = 1
    end
    
    -- Invertir dirección si el debuff está activo
    if self.invertedControls then
        moveDir = -moveDir
    end
    
    self.x = self.x + moveDir * self.speed * dt

    -- Limitar dentro de la pantalla (Ancho de ventana = 800)
    if self.x < 0 then
        self.x = 0
    elseif self.x > 800 - self.w then
        self.x = 800 - self.w
    end
end

function Paddle:draw()
    love.graphics.setColor(0.3, 0.6, 0.9) -- Azul/Celeste metalico
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h, 6, 6) -- esquinas redondeadas
    -- Dibujar borde
    love.graphics.setColor(0.1, 0.2, 0.4)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h, 6, 6)
end

function Paddle:moveLeft()
end

function Paddle:moveRight()
end

function Paddle:catchPower(power)
end

return Paddle