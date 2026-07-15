local Ball = {}
Ball.__index = Ball

function Ball.new()
    local self = setmetatable({
        x = 392,
        y = 530,
        w = 16,
        h = 16,
        vx = 0,
        vy = 0,
        maxVx = 400,
        speed = 400
    }, Ball)
    return self
end

function Ball:reset()
    self.x = 392
    self.y = 530
    self.vx = 0
    self.vy = 0
end

function Ball:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end

function Ball:draw()
    love.graphics.setColor(0.9, 0.9, 0.9) -- Blanco/gris claro
    love.graphics.circle("fill", self.x + self.w/2, self.y + self.h/2, self.w/2)
    -- Dibujar brillo
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("fill", self.x + self.w/3, self.y + self.h/3, self.w/6)
end

function Ball:bounceOnPaddle(paddle)
    -- Reubica la bola encima de la paleta para evitar atasco
    self.y = paddle.y - self.h
    
    local centroBola = self.x + self.w / 2
    local centroPaleta = paddle.x + paddle.w / 2
    local t = (centroBola - centroPaleta) / (paddle.w / 2) -- rango -1 a +1
    
    -- Preservar la magnitud de la velocidad actual para mantener el efecto de Frenar/Veloz
    local speed = math.sqrt(self.vx^2 + self.vy^2)
    if speed < 200 then speed = 380 end -- Velocidad mínima de salvaguarda
    
    -- Calcular ángulo de rebote basado en el punto de contacto (máximo ~56 grados)
    local angle = t * (math.pi / 3.2)
    self.vx = speed * math.sin(angle)
    self.vy = -speed * math.cos(angle)
end

return Ball